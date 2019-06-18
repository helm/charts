# Spinnaker Chart

[Spinnaker](http://spinnaker.io/) is an open source, multi-cloud continuous delivery platform.

## Chart Details
This chart will provision a fully functional and fully featured Spinnaker installation
that can deploy and manage applications in the cluster that it is deployed to.

Redis and Minio are used as the stores for Spinnaker state.

For more information on Spinnaker and its capabilities, see it's [documentation](http://www.spinnaker.io/docs).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/spinnaker --timeout 600
```

Note that this chart pulls in many different Docker images so can take a while to fully install.

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/spinnaker
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Adding Kubernetes Clusters to Spinnaker

By default, installing the chart only registers the local cluster as a deploy target
for Spinnaker. If you want to add arbitrary clusters need to do the following:

1. Upload your kubeconfig to a secret with the key `config` in the cluster you are installing Spinnaker to.

```shell
$ kubectl create secret generic --from-file=$HOME/.kube/config my-kubeconfig
```

1. Set the following values of the chart:

```yaml
kubeConfig:
  enabled: true
  secretName: my-kubeconfig
  secretKey: config
  contexts:
  # Names of contexts available in the uploaded kubeconfig
  - my-context
  # This is the context from the list above that you would like
  # to deploy Spinnaker itself to.
  deploymentContext: my-context
```

## Specifying Docker Registries and Valid Images (Repositories)

Spinnaker will only give you access to Docker images that have been whitelisted, if you're using a private registry or a private repository you also need to provide credentials.  Update the following values of the chart to do so:

```yaml
dockerRegistries:
- name: dockerhub
  address: index.docker.io
  repositories:
    - library/alpine
    - library/ubuntu
    - library/centos
    - library/nginx
# - name: gcr
#   address: https://gcr.io
#   username: _json_key
#   password: '<INSERT YOUR SERVICE ACCOUNT JSON HERE>'
#   email: 1234@5678.com
```

You can provide passwords as a Helm value, or you can use a pre-created secret containing your registry passwords.  The secret should have an item per Registry in the format: `<registry name>: <password>`. In which case you'll specify the secret to use in `dockerRegistryAccountSecret` like so:

```yaml
dockerRegistryAccountSecret: myregistry-secrets
```

## Specifying persistent storage

Spinnaker supports [many](https://www.spinnaker.io/setup/install/storage/) persistent storage types. Currently, this chart supports the following:

* Azure Storage
* Google Cloud Storage
* Minio (local S3-compatible object store)
* Redis
* AWS S3

## Customizing your installation

### Manual
While the default installation is ready to handle your Kubernetes deployments, there are
many different integrations that you can turn on with Spinnaker. In order to customize
Spinnaker, you can use the [Halyard](https://www.spinnaker.io/reference/halyard/) command line `hal`
to edit the configuration and apply it to what has already been deployed.

Halyard has an in-cluster daemon that stores your configuration. You can exec a shell in this pod to
make and apply your changes. The Halyard daemon is configured with a persistent volume to ensure that
your configuration data persists any node failures, reboots or upgrades.

For example:

```shell
$ helm install -n cd stable/spinnaker
$ kubectl exec -it cd-spinnaker-halyard-0 bash
spinnaker@cd-spinnaker-halyard-0:/workdir$ hal version list
```

### Automated
If you have known set of commands that you'd like to run after the base config steps or if
you'd like to override some settings before the Spinnaker deployment is applied, you can enable
the `halyard.additionalScripts.enabled` flag. You will need to create a config map that contains a key
containing the `hal` commands you'd like to run. You can set the key via the config map name via `halyard.additionalScripts.configMapName` and the key via `halyard.additionalScripts.configMapKey`. The `DAEMON_ENDPOINT` environment variable can be used in your custom commands to
get a prepopulated URL that points to your Halyard daemon within the cluster. The `HAL_COMMAND` environment variable does this for you. For example:

```shell
hal --daemon-endpoint $DAEMON_ENDPOINT config security authn oauth2 enable
$HAL_COMMAND config security authn oauth2 enable
```

If you would rather the chart make the config file for you, you can set `halyard.additionalScripts.create` to `true` and then populate `halyard.additionalScripts.data.SCRIPT_NAME.sh` with the bash script you'd like to run. If you need associated configmaps or secrets you can configure those to be created as well:

```yaml
halyard:
  additionalScripts:
    create: true
    data:
      enable_oauth.sh: |-
        echo "Setting oauth2 security"
        $HAL_COMMAND config security authn oauth2 enable
  additionalSecrets:
    create: true
    data:
      password.txt: aHVudGVyMgo=
  additionalConfigMaps:
    create: true
    data:
      metadata.xml: <xml><username>admin</username></xml>
  additionalProfileConfigMaps:
    create: true
    data:
      orca-local.yml: |-
        tasks:
          useManagedServiceAccounts: true
```

Any files added through `additionalConfigMaps` will be written to disk at `/opt/halyard/additionalConfigMaps`.

### Set custom annotations for the halyard pod

```yaml
halyard:
  annotations:
    iam.amazonaws.com/role: <role_arn>
```

### Set environment variables on the halyard pod

```yaml
halyard:
  env:
    - name: DEFAULT_JVM_OPTS
      value: -Dhttp.proxyHost=proxy.example.com
```
