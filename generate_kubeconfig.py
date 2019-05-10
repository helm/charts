#!/usr/bin/python
# Copyright (c) YugaByte, Inc.

# This script would generate a kubeconfig for the given servie account
# by fetching the cluster information and also add the service account
# token for the authentication purpose.

import argparse
from subprocess import check_output
import json
import base64
import tempfile


def run_command(command_args, namespace=None, as_json=True):
    command = ['kubectl']
    if namespace:
        command.extend(['--namespace', namespace])
    command.extend(command_args)
    if as_json:
        command.extend(['-o', 'json'])
        return json.loads(check_output(command))
    else:
        return check_output(command)


parser = argparse.ArgumentParser(description='Generate KubeConfig with Token')
parser.add_argument('-s', '--service_account', help='Service Account name', required=True)
parser.add_argument('-n', '--namespace', help='Kubernetes namespace', default='kube-system')
parser.add_argument('-c', '--context', help='kubectl context')
args = vars(parser.parse_args())

# if the context is not provided we use the current-context
context = args['context']
if context is None:
    context = run_command(['config', 'current-context'],
                          args['namespace'], as_json=False)

cluster_attrs = run_command(['config', 'get-contexts', context.strip(),
                             '--no-headers'], args['namespace'], as_json=False)

cluster_name = cluster_attrs.strip().split()[2]
endpoint = run_command(['config', 'view', '-o',
                        'jsonpath="{.clusters[?(@.name =="' +
                        cluster_name + '")].cluster.server}"'],
                       args['namespace'], as_json=False)
service_account_info = run_command(['get', 'sa', args['service_account']],
                                   args['namespace'])
sa_secret = service_account_info['secrets'][0]['name']
secret_data = run_command(['get', 'secret', sa_secret], args['namespace'])
context_name = '{}-{}'.format(args['service_account'], cluster_name)
kube_config = '/tmp/{}.conf'.format(args['service_account'])

with tempfile.NamedTemporaryFile() as ca_crt_file:
    ca_crt = base64.b64decode(secret_data['data']['ca.crt'])
    ca_crt_file.write(ca_crt)
    ca_crt_file.flush()
    # create kubeconfig entry
    set_cluster_cmd = ['config', 'set-cluster', cluster_name,
                       '--kubeconfig={}'.format(kube_config),
                       '--server={}'.format(endpoint.strip('"')),
                       '--embed-certs=true',
                       '--certificate-authority={}'.format(ca_crt_file.name)]
    run_command(set_cluster_cmd, as_json=False)

user_token = base64.b64decode(secret_data['data']['token'])
set_credentials_cmd = ['config', 'set-credentials', context_name,
                       '--token={}'.format(user_token),
                       '--kubeconfig={}'.format(kube_config)]
run_command(set_credentials_cmd, as_json=False)

set_context_cmd = ['config', 'set-context', context_name,
                   '--cluster={}'.format(cluster_name),
                   '--user={}'.format(context_name),
                   '--kubeconfig={}'.format(kube_config)]
run_command(set_context_cmd, as_json=False)

use_context_cmd = ['config', 'use-context', context_name,
                   '--kubeconfig={}'.format(kube_config)]
run_command(use_context_cmd, as_json=False)

print("Generated the kubeconfig file: {}".format(kube_config))
