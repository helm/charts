#!/usr/bin/env python3
"""Fetch dashboards from provided urls into this chart."""
import json
import textwrap
from os import makedirs, path

import requests
import yaml
from yaml.representer import SafeRepresenter


# https://stackoverflow.com/a/20863889/961092
class LiteralStr(str):
    pass


def change_style(style, representer):
    def new_representer(dumper, data):
        scalar = representer(dumper, data)
        scalar.style = style
        return scalar

    return new_representer


# Source files list
charts = [
    {
        'source': 'https://raw.githubusercontent.com/coreos/kube-prometheus/master/manifests/grafana-dashboardDefinitions.yaml',
        'destination': '../templates/grafana/dashboards-1.14',
        'type': 'yaml',
        'min_kubernetes': '1.14.0-0',
        'max_kubernetes': '1.16.0-0'
    },
    {
        'source': 'https://raw.githubusercontent.com/etcd-io/etcd/master/Documentation/op-guide/grafana.json',
        'destination': '../templates/grafana/dashboards-1.14',
        'type': 'json',
        'min_kubernetes': '1.14.0-0',
        'max_kubernetes': '1.16.0-0'
    },
    {
        'source': 'https://raw.githubusercontent.com/coreos/kube-prometheus/release-0.1/manifests/grafana-dashboardDefinitions.yaml',
        'destination': '../templates/grafana/dashboards',
        'type': 'yaml',
        'min_kubernetes': '1.11.0-0',
        'max_kubernetes': '1.14.0-0'
    },
    {
        'source': 'https://raw.githubusercontent.com/etcd-io/etcd/master/Documentation/op-guide/grafana.json',
        'destination': '../templates/grafana/dashboards',
        'type': 'json',
        'min_kubernetes': '1.11.0-0',
        'max_kubernetes': '1.14.0-0'
    },
]

# Additional conditions map
condition_map = {
    'grafana-coredns-k8s': ' .Values.coreDns.enabled',
    'etcd': ' .Values.kubeEtcd.enabled',
    'apiserver': ' .Values.kubeApiServer.enabled',
    'controller-manager': ' .Values.kubeControllerManager.enabled',
    'kubelet': ' .Values.kubelet.enabled',
    'proxy': ' .Values.kubeProxy.enabled',
    'scheduler': ' .Values.kubeScheduler.enabled'
}

# standard header
header = '''# Generated from '%(name)s' from %(url)s
# Do not change in-place! In order to change this file first read following link:
# https://github.com/helm/charts/tree/master/stable/prometheus-operator/hack
{{- if and (semverCompare ">=%(min_kubernetes)s" .Capabilities.KubeVersion.GitVersion) (semverCompare "<%(max_kubernetes)s" .Capabilities.KubeVersion.GitVersion) .Values.grafana.enabled .Values.grafana.defaultDashboardsEnabled%(condition)s }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ printf "%%s-%%s" (include "prometheus-operator.fullname" $) "%(name)s" | trunc 63 | trimSuffix "-" }}
  labels:
    {{- if $.Values.grafana.sidecar.dashboards.label }}
    {{ $.Values.grafana.sidecar.dashboards.label }}: "1"
    {{- end }}
    app: {{ template "prometheus-operator.name" $ }}-grafana
{{ include "prometheus-operator.labels" $ | indent 4 }}
data:
'''


def init_yaml_styles():
    represent_literal_str = change_style('|', SafeRepresenter.represent_str)
    yaml.add_representer(LiteralStr, represent_literal_str)


def escape(s):
    return s.replace("{{", "{{`{{").replace("}}", "}}`}}")


def yaml_str_repr(struct, indent=2):
    """represent yaml as a string"""
    text = yaml.dump(
        struct,
        width=1000,  # to disable line wrapping
        default_flow_style=False  # to disable multiple items on single line
    )
    text = escape(text)  # escape {{ and }} for helm
    text = textwrap.indent(text, ' ' * indent)
    return text


def write_group_to_file(resource_name, content, url, destination, min_kubernetes, max_kubernetes):
    # initialize header
    lines = header % {
        'name': resource_name,
        'url': url,
        'condition': condition_map.get(resource_name, ''),
        'min_kubernetes': min_kubernetes,
        'max_kubernetes': max_kubernetes
    }

    filename_struct = {resource_name + '.json': (LiteralStr(content))}
    # rules themselves
    lines += yaml_str_repr(filename_struct)

    # footer
    lines += '{{- end }}'

    filename = resource_name + '.yaml'
    new_filename = "%s/%s" % (destination, filename)

    # make sure directories to store the file exist
    makedirs(destination, exist_ok=True)

    # recreate the file
    with open(new_filename, 'w') as f:
        f.write(lines)

    print("Generated %s" % new_filename)


def main():
    init_yaml_styles()
    # read the rules, create a new template file per group
    for chart in charts:
        print("Generating rules from %s" % chart['source'])
        response = requests.get(chart['source'])
        if response.status_code != 200:
            print('Skipping the file, response code %s not equals 200' % response.status_code)
            continue
        raw_text = response.text
        if chart['type'] == 'yaml':
            yaml_text = yaml.load(raw_text)
            groups = yaml_text['items']
            for group in groups:
                for resource, content in group['data'].items():
                    write_group_to_file(resource.replace('.json', ''), content, chart['source'], chart['destination'], chart['min_kubernetes'], chart['max_kubernetes'])
        elif chart['type'] == 'json':
            json_text = json.loads(raw_text)
            # is it already a dashboard structure or is it nested (etcd case)?
            flat_structure = bool(json_text.get('annotations'))
            if flat_structure:
                resource = path.basename(chart['source']).replace('.json', '')
                write_group_to_file(resource, json.dumps(json_text, indent=4), chart['source'], chart['destination'], chart['min_kubernetes'], chart['max_kubernetes'])
            else:
                for resource, content in json_text.items():
                    write_group_to_file(resource.replace('.json', ''), json.dumps(content, indent=4), chart['source'], chart['destination'], chart['min_kubernetes'], chart['max_kubernetes'])
    print("Finished")


if __name__ == '__main__':
    main()
