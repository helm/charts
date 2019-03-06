
# Code Dx

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Code Dx](https://codedx.com/) is an automated application vulnerability management tool that makes all of your testing tools work together to provide one set of correlated results, then helps you prioritize and manage vulnerabilities — integrating with your application lifecycle management tools so your security and development teams work together for faster remediation.

The Code Dx Helm chart creates an environment for development and test purposes. It may be used in production but has not been heavily tested.

## TL;DR

```
$ git clone https://github.com/codedx/codedx-kubernetes.git
$ git checkout develop
$ cd incubator/codedx
$ helm dependency update
$ helm install --name codedx .
```

## Prerequisite Details

- Kubernetes 1.8+
- Code Dx license ([purchase](https://codedx.com/purchase-application/) or [request a free trial](https://codedx.com/free-trial/)) 

## Chart Details

This chart will:

- Deploy a Code Dx instance
- Deploy the MariaDB chart with master and slaves
- Create service accounts, PodSecurityPolicies, and NetworkPolicies

![Kubernetes Deployment Diagram](CodeDxK8s.png)

## Installing the Chart

Using this chart requires [Helm](https://docs.helm.sh/), a Kubernetes package manager. You can find instructions for installing and initializing Helm [here](https://docs.helm.sh/using_helm/). Make sure that a `tiller-deploy` pod is ready before continuing. (`kubectl get pods -n kube-system`) Also make sure that the `tiller-deploy` pod has the necessary permissions via RBAC and a PodSecurityPolicy, if necessary.

A set of RBAC resources and PSP for Helm can be found in this repository, at [helm-tiller-resources.yaml](incubator/codedx/helm-tiller-resources.yaml). Download the file and run `kubectl create -f helm-tiller-resources.yaml` if RBAC and PodSecurityPolicies are enabled for your cluster. After running `helm init`, run `helm init --upgrade --service-account helm-tiller` to use the new resources.

This chart contains a reference to stable/mariadb chart version 5.5.0, which deploys MariaDB 10.1.37. When first installing, you'll need to download the MariaDB chart:

```
$ helm dependency update
```

To install the chart with a `codedx` release name, run the following command from the incubator/codedx directory:

```
$ helm install --name codedx .
```

After installation, you'll be given commands to retrieve the Code Dx admin credentials that were generated. Use `kubectl get pods --watch` to check the status of the Code Dx installation. Change the Code Dx admin password once installation is complete. Calls to `helm upgrade` on Code Dx will modify the password stored in its secret, but will not change the actual password used by Code Dx. `kubectl` calls for getting the admin password will given different results every time `helm upgrade` is used.

**Before installing, you should first read the recommendations below.**

### Installation Recommendations

When installing the chart in a public-facing environment, be sure to change the passwords for MariaDB Admin and MariaDB Replication. These passwords are not randomly generated and are nontrivial to change after installation.

```
$ helm install --name codedx . --set mariadb.rootUser.password=X --set mariadb.replication.password=Y
```

It's recommended to leave PodSecurityPolicies and NetworkPolicies enabled for security. Note that controllers need to be available on the cluster to enforce these policies.

The default volume sizes for Code Dx and MariaDB are `32Gi` - `96Gi` total for the chart, by default. (One volume for Code Dx, one for MariaDB Master, and one for MariaDB Slave.) `32Gi` is not the minimum disk size - the chart can run with a `100Mi` volume for Code Dx and `1Gi` volumes for MariaDB. However, this will quickly fill up and can cause maintenance headaches. Keep in mind that source code, binaries, and scan results will be uploaded to and stored by Code Dx. The size of these files, frequency of scanning, and number of projects should be considered when determining an initial volume size. Expect MariaDB disk usage to be approximately equivalent to Code Dx.

For more configuration options, see the table below.

## Uninstalling the Chart

To uninstall a chart with a `codedx` release name, run the following command (add `--purge` to permit the reuse of the `codedx` release name):

```
$ helm delete codedx
```

To remove the MariaDB persistent volume claims, run the following command:

```
$ kubectl delete pvc data-codedx-mariadb-master-0 data-codedx-mariadb-slave-0
```

## Configuration

The following table lists the configurable parameters of the Code Dx chart and their default values.

| Parameter                               | Description                                                                                                                                                                                        | Default                              |
|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|
| `codedxTomcatImage`                     | Code Dx Tomcat image full name                                                                                                                                                                     | `codedx/codedx-tomcat:v3.6.0`        |
| `codedxTomcatImagePullSecrets`          | Pull secrets for Code Dx Tomcat image                                                                                                                                                              | `[]`                                 |
| `codedxTomcatPort`                      | Port for Code Dx Tomcat service                                                                                                                                                                    | `9090`                               |
| `codedxJavaOpts`                        | Extra options passed to Tomcat JVM                                                                                                                                                                 | `""`                                 |
| `codedxAdminPassword`                   | Password for Code Dx 'admin' account created at installation (random if empty)                                                                                                                     | `""`                                 |
| `serviceAccount.create`                 | Whether to create a ServiceAccount for Code Dx                                                                                                                                                     | `true`                               |
| `serviceAccount.name`                   | Name of the ServiceAccount for Code Dx                                                                                                                                                             |                                      |
| `podSecurityPolicy.codedx.create`       | Whether to create a PodSecurityPolicy for Code Dx pods                                                                                                                                             | `true`                               |
| `podSecurityPolicy.codedx.name`         | Name of the PodSecurityPolicy for Code Dx pods                                                                                                                                                     |                                      |
| `podSecurityPolicy.codedx.bind`         | Whether to bind the PodSecurityPolicy to Code Dx's ServiceAccount                                                                                                                                  | `true`                               |
| `podSecurityPolicy.mariadb.create`      | Whether to create a PodSecurityPolicy for MariaDB pods                                                                                                                                             | `true`                               |
| `podSecurityPolicy.mariadb.name`        | Name of the PodSecurityPolicy for MariaDB pods                                                                                                                                                     |                                      |
| `podSecurityPolicy.mariadb.bind`        | Whether to bind the PodSecurityPolicy to MariaDB's ServiceAccount                                                                                                                                  | `true`                               |
| `networkPolicy.codedx.create`           | Whether to create a NetworkPolicy for Code Dx                                                                                                                                                      | `true`                               |
| `networkPolicy.codedx.ldap`             | Whether to include a rule for allowing LDAP egress (port 389)                                                                                                                                      | `false`                              |
| `networkPolicy.codedx.ldaps`            | Whether to include a rule for allowing LDAPS egress (ports 636, 3269)                                                                                                                              | `false`                              |
| `networkPolicy.codedx.http`             | Whether to include a rule for allowing HTTP egress (port 80)                                                                                                                                       | `false`                              |
| `networkPolicy.codedx.https`            | Whether to include a rule for allowing HTTPS egress (port 443)                                                                                                                                     | `false`                              |
| `networkPolicy.codedx.ingressSelectors` | [Additional Ingress selectors for the Code Dx NetworkPolicy against `codedxTomcatPort`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#networkpolicypeer-v1beta1-extensions) | `[]`                                 |
| `networkPolicy.mariadb.master.create`   | Whether to create a NetworkPolicy for the MariaDB Master                                                                                                                                           | `true`                               |
| `networkPolicy.mariadb.slave.create`    | Whether to create a NetworkPolicy for the MariaDB Slave                                                                                                                                            | `true`                               |
| `persistence.storageClass`              | Explicit storage class for Code Dx's appdata volume claim                                                                                                                                          | `""`                                 |
| `persistence.accessMode`                | Access mode for Code Dx's appdata volume claim                                                                                                                                                     | `ReadWriteOnce`                      |
| `persistence.size`                      | Size of Code Dx's appdata volume claim                                                                                                                                                             | `100Mi`                              |
| `persistence.existingClaim`             | The name of an existing volume claim to use for Code Dx's appdata                                                                                                                                  |                                      |
| `ingress.enabled`                       | Whether to create an Ingress resource for Code Dx                                                                                                                                                  | `false`                              |
| `ingress.annotations`                   | Additional annotations for a generated Code Dx Ingress resource                                                                                                                                    | NGINX proxy read-timeout + body-size |
| `ingress.hosts`                         | The list of Code Dx hosts to generate Ingress resources for                                                                                                                                        | `[sample]`                           |
| `ingress.hosts[i].name`                 | The FQDN of a Code Dx host                                                                                                                                                                         |                                      |
| `ingress.hosts[i].tls`                  | Whether to add HTTPS/TLS properties to the generated Ingress resource                                                                                                                              |                                      |
| `ingress.hosts[i].tlsSecret`            | The name of the TLS secret containing corresponding key and cert                                                                                                                                   |                                      |
| `ingress.secrets`                       | List of secrets to generate for use in TLS                                                                                                                                                         | `[]`                                 |
| `ingress.secrets[i].name`               | Name of the secret to be created                                                                                                                                                                   |                                      |
| `ingress.secrets[i].key`                | Base64-encoded encryption key                                                                                                                                                                      |                                      |
| `ingress.secrets[i].keyFile`            | Path to encryption key file (ignored if `key` is specified)                                                                                                                                        |                                      |
| `ingress.secrets[i].certificate`        | Base64-encoded encryption certificate                                                                                                                                                              |                                      |
| `ingress.secrets[i].certificateFile`    | Path to encryption certificate file (ignored if `certificate` is specified)                                                                                                                        |                                      |
| `serviceType`                           | Service type for Code Dx                                                                                                                                                                           | Based on Ingress config              |
| `codedxProps.file`                      | Location of a Code Dx `props` file for configuration                                                                                                                                               | `codedx.props`                       |
| `codedxProps.configMap`                 | Name of the ConfigMap that will store the Code Dx `props` file                                                                                                                                     |                                      |
| `codedxProps.annotations`               | Extra annotations attached to a generated codedx `props` ConfigMap                                                                                                                                 | `{}`                                 |
| `codedxProps.dbconnection.createSecret` | Whether to create a secret containing MariaDB creds                                                                                                                                                | `true`                               |
| `codedxProps.dbconnection.secretName`   | Name of the secret containing MariaDB creds                                                                                                                                                        |                                      |
| `codedxProps.dbconnection.annotations`  | Extra annotations attached to a generated MariaDB secret                                                                                                                                           | `{}`                                 |
| `codedxProps.extra`                     | List of extra secrets containing Code Dx props to be loaded                                                                                                                                        | `[]`                                 |
| `codedxProps.extra[i].secretName`       | Name of the secret to be loaded and mounted                                                                                                                                                        |                                      |
| `codedxProps.extra[i].key`              | Name of the key within the secret that contains Code Dx props text                                                                                                                                 |                                      |
| `license.file`                          | Location of a license for Code Dx to use during installation                                                                                                                                       |                                      |
| `license.secret`                        | Name of the secret that will store the Code Dx license                                                                                                                                             |                                      |
| `license.annotations`                   | Extra annotations attached to a Code Dx License secret                                                                                                                                             |                                      |
| `loggingConfigFile`                     | Location of a `logback.xml` file to customize Code Dx logging                                                                                                                                      |                                      |
| `resources`                             | Defines resource requests and limits for Code Dx                                                                                                                                                   |                                      |
| `mariadb.rootUser.password`             | Password for the MariaDB root user                                                                                                                                                                 | `5jqJL2b8hqn3`                       |
| `mariadb.replication.password`          | Password for the MariaDB replication server                                                                                                                                                        | `11uAQKLgv4JM`                       |
| `mariadb.serviceAccount.create`         | Whether to create a ServiceAccount for MariaDB                                                                                                                                                     | `true`                               |
| `mariadb.serviceAccount.name`           | Name of the ServiceAccount used by MariaDB                                                                                                                                                         |                                      |
| `mariadb.*`                             | [Extra MariaDB props found in its own chart](https://github.com/helm/charts/blob/master/stable/mariadb/README.md#configuration)                                                                    |                                      |

## Replication/Scalability

Code Dx does not officially support horizontal scaling. Attempting to use more than one replica for the Code Dx deployment can lead to bugs while using Code Dx, and possibly corruption of your database. Work is being done within Code Dx to better support this.

## Persistence

Code Dx will store all data in its `/opt/codedx` folder in a PersistentVolume. This includes log files, which are written both to disk and to `stdout`. The full list of data is:

- Log files from Code Dx and its tools
- Files uploaded for analysis (source code, binaries, scans)
- Temporary files (files extracted from ZIPs)

**Depending on the projects being scanned, the default size may not be sufficient. Be sure to specify an appropriate claim size when installing Code Dx.**

## Licenses

By default, Code Dx will be installed without a license. When you first navigate to Code Dx after installation, you will first be asked for a license. You can include a license during the installation process using the `license.file` and/or `license.secret` values. Note that this approach only applies for a new installation, and will have no effect afterwards.

If you have a Code Dx license file that you want to use, copy it to your current working directory and install Code Dx using helm:

```
helm install stable/codedx --name codedx --set license.file="my-codedx-license.lic"
```

Code Dx will create a Secret containing the contents of `my-codedx-license.lic`, which is mounted as a file and read by Code Dx during installation.

If you have a Code Dx license already stored as a secret, you can specify `license.secret` instead to use that existing secret:

```
helm install stable/codedx --name codedx --set license.secret="my-codedx-license-secret"
```

Note that the given secret must have a key named `license.lic`, with the contents of your Code Dx license.

## Code Dx Configuration

### General

Configuration of Code Dx itself is done through a primary ConfigMap and Secrets. A ConfigMap is generated when installing Code Dx with a `codedx.props` entry that contains common properties, such as configuration of tools, reports, and other miscellaneous behavior. To edit common Code Dx configuration, edit the `codedx.props` entry of the ConfigMap and delete the Code Dx pod to restart Code Dx with the new settings.

### Sensitive Information

Some properties, such as MariaDB or LDAP connection information, is stored in Secrets instead. These Secrets contain similar `codedx.props`-formatted content, which are also mounted as files. The file paths are then passed to Code Dx and loaded during installation and startup.

File paths are passed to Code Dx in the same ConfigMap containing common `codedx.props`, but is contained in the `tomcat.env` entry instead. This entry contains `export CATALINA_OPTS=...`, where `...` is the list of parameters to pass to Code Dx.

For loading extra `props` files, we want to add parameters such as: `-Dcodedx.additional-props-x=/path/to/props`. The `-D` part causes this parameter to be passed to Code Dx directly. Code Dx checks for any parameters starting with `codedx.additional-props` and load the file paths assigned to each.

Parameters for different files should be separated by a space, and file paths should not contain special characters or spaces for simplicity.

After making your changes to the ConfigMap, make sure the associated Secret exists in Kubernetes. Edit the Code Dx Deployment to mount your Secret as a file at the location you passed in the `-Dcodedx.additional-props...` parameter. Save and exit the editor. The old Code Dx pod should begin terminating, and a new pod will start after this completes. Check the logs for the new pod to make sure that the file was successfully loaded - the log file should contain a message such as:

```
Loaded additional props file from <YOUR-PATH> using X syntax, based on the system property <YOUR-PARAM-NAME>.
```

### LDAP(s) and External Tools - cacerts

When configuring Code Dx to connect via LDAPS or an external tool, there are two considerations - accepting TLS certs and enabling egress from Code Dx to these services.

#### cacerts

Java applications generally use a _cacerts_ file, which is a collection of certs used to authenticate peers. Any connection using TLS will reference the available certs in this file. For LDAPS and external tools using HTTPS, their cert may need to be imported into _cacerts_ for Code Dx to complete connections to those services. Information for installing a cert into a _cacerts_ file [can be found in the Code Dx Install Guide](https://codedx.com/Documentation/InstallGuide.html#TrustingSelfSignedCertificates). Note that, while that guide modifies the _cacerts_ file directly on the installed machine, you will be modifying a Secret instead that will be mounted as the _cacerts_ file within Code Dx.

This chart accepts a `cacertsFile` value, which is the path to a file on your local machine that will be stored in a Secret and mounted by Code Dx. When installing, you can use `--set cacertsFile=my/path/cacerts` to specify your _cacerts_ file. If changing the _cacerts_ file after installation, you should use `helm upgrade {my-codedx} . --set cacertsFile=my/path/updatedCacerts`. Using the `helm upgrade` command will automatically create a new (or modify an existing) secret with the contents of your _cacerts_ file. It will also update the Code Dx deployment to mount that secret appropriately. (Note that, if the _cacerts_ secret already exists, Code Dx will not see changes to the updated secret until it's restarted.)

You can get the current _cacerts_ file from an existing Code Dx container with:

```
kubectl cp <CODEDX-POD-NAME>:/etc/ssl/certs/java/cacerts .
```

#### Egress

If NetworkPolicies are not in use in your cluster, this can be ignored. Otherwise, the network policy for the Code Dx container will need to permit egress on the appropriate ports. For well-known ports LDAP(s) and HTTP(s), you can update the network policy with:

```
helm upgrade {my-codedx} . \
    --set networkPolicy.codedx.ldap=true \
    --set networkPolicy.codedx.ldaps=true \
    --set networkPolicy.codedx.http=true \
    --set networkPolicy.codedx.https=true \
```

For any other ports, the NetworkPolicy will need to be edited manually with `kubectl edit networkpolicy ...`.

## Ingress

This chart can automatically create an Ingress resource for Code Dx. To do this, set `ingress.enabled=true` and add an appropriate entry to `ingress.hosts`. Setting `ingress.enabled=true` automatically sets Code Dx's Service type to `NodePort` rather than `LoadBalancer`.

An example installation with Ingress, without HTTPS:

```
helm install --name codedx \
    --set ingress.enabled=true \
    --set ingress.hosts[0].name="codedx.company.com"
    --set ingress.tls=false
```

An example with HTTPS, using an existing TLS secret:

```
helm install --name codedx \
    --set ingress.enabled=true \
    --set ingress.hosts[0].name="codedx.company.com"
    --set ingress.hosts[0].tls=true
    --set ingress.hosts[0].tlsSecret=my-tls-secret
```

An example with HTTPS, using custom annotations to enable TLS-ACME (a values.yaml file):

```
ingress:
  enabled: true
  annotations:
    kubernetes.io/tls-acme: "true"
  hosts:
  - name: codedx.company.com
    tls: true
```

**Note that the Ingress Annotations contains NGINX annotations by default to increase the read timeout and remove the proxy request body size limit.** This is to prevent errors for Code Dx live-updates and for uploading large files, respectively. If using a different Ingress implementation, make sure to include the appropriate annotations.

## Upgrading Code Dx

The Code Dx deployment is using a `Replicate` deployment strategy and only one replica by default, ensuring that no more than one instance of Code Dx is operating against a database at any given time. This is particularly important during upgrades of the Code Dx image. If a database schema update occurs while more than once instance of Code Dx is running against that database, it will lead to errors, data loss, and possibly corruption of the database.

This does mean that zero-downtime updates are not currently possible with Code Dx. Research is being done to better support this.

To upgrade Code Dx to a new version, first [find the Code Dx version to upgrade to on Docker.](https://hub.docker.com/r/codedx/codedx-tomcat/tags) **Note that only Code Dx v3.6.0 and higher are kubernetes-compatible.** Then change the image used in the Code Dx deployment. There are two approaches for this - `kubectl edit deploy` and `helm upgrade`.

Note that your license will carry over to the new version and all data will be retained if the upgrade is performed properly.

### Upgrade by Modifying the Deployment

Modify the Code Dx deployment manually with the new version via `kubectl edit deploy <codedx-deploy-name>` and change the `spec.template.spec.containers.image` property. Save and exit your editor.

### Upgrade using Helm

Navigate to the Code Dx chart directory in a terminal and run `helm upgrade --set codedxTomcatVersion=<new-codedx-image> <codedx-installation-name> .`, where:

- `<new-codedx-image>`: The full name of a Code Dx image [from docker](https://hub.docker.com/r/codedx/codedx-tomcat/tags), ie `codedx/codedx-tomcat:v3.6.0`
- `<codedx-installation-name>`: The name of the Code Dx installation, which is set when installing Code Dx via `helm install`. If installed via `helm install --name my-install ...`, the installation name would be `my-install`. If no name was specified, it will default to `codedx`.

**Be sure to include any additional values used in previous upgrades or installations.** If you passed a custom `values.yaml` file via `-f my-values.yaml`, make sure to include this file during the upgrade call. Otherwise, helm may modify Code Dx in unintended ways.

### Confirming a Successful Upgrade

Running `kubectl get pods --watch` should show the old Code Dx pod terminating. Another Code Dx pod will be created after the old pod finishes, and will begin the installation process before continuing to start up normally. Once the pod shows a status of `READY 1/1`, navigate to Code Dx and you should be able to sign in. The Code Dx version and build date on the top-right of the page should be updated accordingly.