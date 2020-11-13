# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Spinnaker Chart

[Spinnaker](http://spinnaker.io/) is an open source, multi-cloud continuous delivery platform.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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

### Configuring arbitrary clusters with a kubernetes secret
By default, installing the chart only registers the local cluster as a deploy target
for Spinnaker. If you want to add arbitrary clusters need to do the following:

1. Upload your kubeconfig to a secret with the key `config` in the cluster you are installing Spinnaker to.

```shell
$ kubectl create secret generic --from-file=$HOME/.kube/config my-kubeconfig
```

2. Set the following values of the chart:

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

### Configuring arbitrary clusters with s3
By default, installing the chart only registers the local cluster as a deploy target
for Spinnaker. If you do not want to store your kubeconfig as a secret on the cluster, you
can also store in s3. Full documentation can be found [here](https://www.spinnaker.io/reference/halyard/secrets/s3-secrets/#secrets-in-s3).

1. Upload your kubeconfig to a s3 bucket that halyard and spinnaker services can access.


2. Set the following values of the chart:

```yaml
kubeConfig:
  enabled: true
  # secretName: my-kubeconfig
  # secretKey: config
  encryptedKubeconfig: encrypted:s3!r:us-west-2!b:mybucket!f:mykubeconfig
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
# - name: ecr
#   address: <AWS-ACCOUNT-ID>.dkr.ecr.<REGION>.amazonaws.com
#   username: AWS
#   passwordCommand: aws --region <REGION> ecr get-authorization-token --output text --query 'authorizationData[].authorizationToken' | base64 -d | sed 's/^AWS://'
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

## Use custom `cacerts`

In environments with air-gapped setup, especially with internal tooling (repos) and self-signed certificates it is required to provide an adequate `cacerts` which overrides the default one:

1. Create a yaml file `cacerts.yaml` with a secret that contanins the `cacerts`

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: custom-cacerts
   data:
     cacerts: |
       xxxxxxxxxxxxxxxxxxxxxxx
   ```

2. Upload your `cacerts.yaml` to a secret with the key you specify in `secretName` in the cluster you are installing Spinnaker to.

   ```shell
   $ kubectl apply -f cacerts.yaml
   ```

3. Set the following values of the chart:

   ```yaml
   customCerts:
      ## Enable to override the default cacerts with your own one
      enabled: false
      secretName: custom-cacerts
   ```

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

If you need to give halyard additional parameters when it deploys Spinnaker, you can specify them with `halyard.additionalInstallParameters`.

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

### Use a custom Halyard BOM

Spinnaker uses a Bill of Materials to describe the services that are part of a release. See the [BOM documentation](https://www.spinnaker.io/guides/operator/custom-boms/#the-bill-of-materials-bom) for more details.   

A [custom BOM](https://www.spinnaker.io/guides/operator/custom-boms/#boms-and-configuration-on-your-filesystem) can be provided to the Helm chart and used for the Halyard deployment: 

```yaml
halyard:
  spinnakerVersion: '1.16.1'
  bom: |-
    artifactSources:
      debianRepository: https://dl.bintray.com/spinnaker-releases/debians
      dockerRegistry: gcr.io/spinnaker-marketplace
      gitPrefix: https://github.com/spinnaker
      googleImageProject: marketplace-spinnaker-release
    dependencies:
      consul:
        version: 0.7.5
      redis:
        version: 2:2.8.4-2
      vault:
        version: 0.7.0
    services:
      clouddriver:
        commit: 031bcec52d6c3eb447095df4251b9d7516ed74f5
        version: 6.3.0-20190904130744
      deck:
        commit: b0aac478e13a7f9642d4d39479f649dd2ef52a5a
        version: 2.12.0-20190916141821
      defaultArtifact: {}
      echo:
        commit: 7aae2141883240bd5747b981b2196adfa5b24225
        version: 2.8.0-20190914075316
      fiat:
        commit: e92cfbcac018d9dcfa03869224f7106bf2a11315
        version: 1.7.0-20190904130744
      front50:
        commit: abc5c168e3619ac084d4130eef7313cbdcfc3f61
        version: 0.19.0-20190904130744
      gate:
        commit: fd0128a6b79ddaca984c3bcdd1259c14f167cd2d
        version: 1.12.0-20190914075316
      igor:
        commit: c9bbca8e5c340d90b812f4fd27c6ebe3088dbc8d
        version: 1.6.0-20190914075316
      kayenta:
        commit: 8aa41e6e723e8d37831f5d4fe0bd5aa24ede5872
        version: 0.11.0-20190830172818
      monitoring-daemon:
        commit: 922385def92058877d61dfc835873539f0377cd7
        version: 0.15.0-20190820135930
      monitoring-third-party:
        commit: 922385def92058877d61dfc835873539f0377cd7
        version: 0.15.0-20190820135930
      orca:
        commit: 7b4e3dd6c4393ba88ebb3ea209a9c95df63e5e87
        version: 2.10.0-20190914075316
      rosco:
        commit: cfb88bb57f7af064876cfe5eef3c330a2621507b
        version: 0.14.0-20190904130744
    timestamp: '2019-09-16 18:18:44'
    version: 1.16.1
```

This will result in the specified BOM contents being written to a `1.16.1.yml` BOM file, and the Spinnaker version set to `local:1.16.1`.  

### Set custom annotations for the halyard pod

```yaml
halyard:
  annotations:
    iam.amazonaws.com/role: <role_arn>
```

### Set custom annotations for the halyard serviceaccount

```yaml
serviceAccount:
  serviceAccountAnnotations:
    eks.amazonaws.com/role-arn: <role_arn>
```

### Set environment variables on the halyard pod

```yaml
halyard:
  env:
    - name: JAVA_OPTS
      value: -Dhttp.proxyHost=proxy.example.com
```
