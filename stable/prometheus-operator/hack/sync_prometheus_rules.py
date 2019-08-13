#!/usr/bin/env python3
"""Fetch alerting and aggregation rules from provided urls into this chart."""
import textwrap
from os import makedirs

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
        'source': 'https://raw.githubusercontent.com/coreos/kube-prometheus/master/manifests/prometheus-rules.yaml',
        'destination': '../templates/prometheus/rules-1.14',
        'min_kubernetes': '1.14.0',
        'max_kubernetes': '1.16.0'
    },
    {
        'source': 'https://raw.githubusercontent.com/etcd-io/etcd/master/Documentation/op-guide/etcd3_alert.rules.yml',
        'destination': '../templates/prometheus/rules-1.14',
        'min_kubernetes': '1.14.0',
        'max_kubernetes': '1.16.0'
    },
    {
        'source': 'https://raw.githubusercontent.com/coreos/kube-prometheus/release-0.1/manifests/prometheus-rules.yaml',
        'destination': '../templates/prometheus/rules',
        'min_kubernetes': '1.11.0',
        'max_kubernetes': '1.14.0'
    },
    {
        'source': 'https://raw.githubusercontent.com/etcd-io/etcd/master/Documentation/op-guide/etcd3_alert.rules.yml',
        'destination': '../templates/prometheus/rules',
        'min_kubernetes': '1.11.0',
        'max_kubernetes': '1.14.0'
    },
]

# Additional conditions map
condition_map = {
    'alertmanager.rules': ' .Values.defaultRules.rules.alertmanager',
    'general.rules': ' .Values.defaultRules.rules.general',
    'k8s.rules': ' .Values.defaultRules.rules.k8s',
    'kube-apiserver.rules': ' .Values.kubeApiServer.enabled .Values.defaultRules.rules.kubeApiserver',
    'kube-prometheus-node-alerting.rules': ' .Values.defaultRules.rules.kubePrometheusNodeAlerting',
    'kube-prometheus-node-recording.rules': ' .Values.defaultRules.rules.kubePrometheusNodeRecording',
    'kube-scheduler.rules': ' .Values.kubeScheduler.enabled .Values.defaultRules.rules.kubeScheduler',
    'kubernetes-absent': ' .Values.defaultRules.rules.kubernetesAbsent',
    'kubernetes-resources': ' .Values.defaultRules.rules.kubernetesResources',
    'kubernetes-storage': ' .Values.defaultRules.rules.kubernetesStorage',
    'kubernetes-system': ' .Values.defaultRules.rules.kubernetesSystem',
    'node.rules': ' .Values.nodeExporter.enabled .Values.defaultRules.rules.node',
    'node-network': ' .Values.defaultRules.rules.network',
    'node-time': ' .Values.defaultRules.rules.time',
    'prometheus-operator': ' .Values.defaultRules.rules.prometheusOperator',
    'prometheus.rules': ' .Values.defaultRules.rules.prometheus',
    'kubernetes-apps': ' .Values.kubeStateMetrics.enabled .Values.defaultRules.rules.kubernetesApps',
    'etcd': ' .Values.kubeEtcd.enabled .Values.defaultRules.rules.etcd',
}

alert_condition_map = {
    'KubeAPIDown': '.Values.kubeApiServer.enabled',  # there are more alerts which are left enabled, because they'll never fire without metrics
    'KubeControllerManagerDown': '.Values.kubeControllerManager.enabled',
    'KubeSchedulerDown': '.Values.kubeScheduler.enabled',
    'KubeStateMetricsDown': '.Values.kubeStateMetrics.enabled',  # there are more alerts which are left enabled, because they'll never fire without metrics
    'KubeletDown': '.Values.prometheusOperator.kubeletService.enabled',  # there are more alerts which are left enabled, because they'll never fire without metrics
    'PrometheusOperatorDown': '.Values.prometheusOperator.enabled',
    'NodeExporterDown': '.Values.nodeExporter.enabled',
    'CoreDNSDown': '.Values.kubeDns.enabled',
    'AlertmanagerDown': '.Values.alertmanager.enabled',
}

replacement_map = {
    'job="prometheus-operator"': {
        'replacement': 'job="{{ $operatorJob }}"',
        'init': '{{- $operatorJob := printf "%s-%s" (include "prometheus-operator.fullname" .) "operator" }}'},
    'job="prometheus-k8s"': {
        'replacement': 'job="{{ $prometheusJob }}"',
        'init': '{{- $prometheusJob := printf "%s-%s" (include "prometheus-operator.fullname" .) "prometheus" }}'},
    'job="alertmanager-main"': {
        'replacement': 'job="{{ $alertmanagerJob }}"',
        'init': '{{- $alertmanagerJob := printf "%s-%s" (include "prometheus-operator.fullname" .) "alertmanager" }}'},
    'namespace="monitoring"': {
        'replacement': 'namespace="{{ $namespace }}"',
        'init': '{{- $namespace := .Release.Namespace }}'},
    'alertmanager-$1': {
        'replacement': '$1',
        'init': ''},
}

# standard header
header = '''# Generated from '%(name)s' group from %(url)s
# Do not change in-place! In order to change this file first read following link:
# https://github.com/helm/charts/tree/master/stable/prometheus-operator/hack
{{- if and (semverCompare ">=%(min_kubernetes)s" .Capabilities.KubeVersion.GitVersion) (semverCompare "<%(max_kubernetes)s" .Capabilities.KubeVersion.GitVersion) .Values.defaultRules.create%(condition)s }}%(init_line)s
apiVersion: {{ printf "%%s/v1" (.Values.prometheusOperator.crdApiGroup | default "monitoring.coreos.com") }}
kind: PrometheusRule
metadata:
  name: {{ printf "%%s-%%s" (include "prometheus-operator.fullname" .) "%(name)s" | trunc 63 | trimSuffix "-" }}
  labels:
    app: {{ template "prometheus-operator.name" . }}
{{ include "prometheus-operator.labels" . | indent 4 }}
{{- if .Values.defaultRules.labels }}
{{ toYaml .Values.defaultRules.labels | indent 4 }}
{{- end }}
{{- if .Values.defaultRules.annotations }}
  annotations:
{{ toYaml .Values.defaultRules.annotations | indent 4 }}
{{- end }}
spec:
  groups:
  -'''


def init_yaml_styles():
    represent_literal_str = change_style('|', SafeRepresenter.represent_str)
    yaml.add_representer(LiteralStr, represent_literal_str)


def escape(s):
    return s.replace("{{", "{{`{{").replace("}}", "}}`}}")


def fix_expr(rules):
    """Remove trailing whitespaces and line breaks, which happen to creep in
     due to yaml import specifics;
     convert multiline expressions to literal style, |-"""
    for rule in rules:
        rule['expr'] = rule['expr'].rstrip()
        if '\n' in rule['expr']:
            rule['expr'] = LiteralStr(rule['expr'])


def yaml_str_repr(struct, indent=4):
    """represent yaml as a string"""
    text = yaml.dump(
        struct,
        width=1000,  # to disable line wrapping
        default_flow_style=False  # to disable multiple items on single line
    )
    text = escape(text)  # escape {{ and }} for helm
    text = textwrap.indent(text, ' ' * indent)[indent - 1:]  # indent everything, and remove very first line extra indentation
    return text


def add_rules_conditions(rules, indent=4):
    """Add if wrapper for rules, listed in alert_condition_map"""
    rule_condition = '{{- if %s }}\n'
    for alert_name in alert_condition_map:
        line_start = ' ' * indent + '- alert: '
        if line_start + alert_name in rules:
            rule_text = rule_condition % alert_condition_map[alert_name]
            # add if condition
            index = rules.index(line_start + alert_name)
            rules = rules[:index] + rule_text + rules[index:]
            # add end of if
            try:
                next_index = rules.index(line_start, index + len(rule_text) + 1)
            except ValueError:
                # we found the last alert in file if there are no alerts after it
                next_index = len(rules)

            # depending on the rule ordering in alert_condition_map it's possible that an if statement from another rule is present at the end of this block.
            found_block_end = False
            last_line_index = next_index
            while not found_block_end:
                last_line_index = rules.rindex('\n', index, last_line_index - 1)  # find the starting position of the last line
                last_line = rules[last_line_index + 1:next_index]

                if last_line.startswith('{{- if'):
                    next_index = last_line_index + 1  # move next_index back if the current block ends in an if statement
                    continue

                found_block_end = True

            rules = rules[:next_index] + '{{- end }}\n' + rules[next_index:]
    return rules


def write_group_to_file(group, url, destination, min_kubernetes, max_kubernetes):
    fix_expr(group['rules'])

    # prepare rules string representation
    rules = yaml_str_repr(group)
    # add replacements of custom variables and include their initialisation in case it's needed
    init_line = ''
    for line in replacement_map:
        if line in rules:
            rules = rules.replace(line, replacement_map[line]['replacement'])
            if replacement_map[line]['init']:
                init_line += '\n' + replacement_map[line]['init']
    # append per-alert rules
    rules = add_rules_conditions(rules)
    # initialize header
    lines = header % {
        'name': group['name'],
        'url': url,
        'condition': condition_map.get(group['name'], ''),
        'init_line': init_line,
        'min_kubernetes': min_kubernetes,
        'max_kubernetes': max_kubernetes
    }

    # rules themselves
    lines += rules

    # footer
    lines += '{{- end }}'

    filename = group['name'] + '.yaml'
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
        yaml_text = yaml.load(raw_text)
        # etcd workaround, their file don't have spec level
        groups = yaml_text['spec']['groups'] if yaml_text.get('spec') else yaml_text['groups']
        for group in groups:
            write_group_to_file(group, chart['source'], chart['destination'], chart['min_kubernetes'], chart['max_kubernetes'])
    print("Finished")


if __name__ == '__main__':
    main()
