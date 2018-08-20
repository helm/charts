# taiga

[Taiga](https://taiga.io/) is a project management platform for agile developers & designers and project managers who want a beautiful tool that makes work truly enjoyable.

This chart is a community effort, and is not endorsed by the taiga project developers.


### TL;DR;

Be sure to have a working [Helm](https://helm.sh) installation for your cluster first.

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name taiga incubator/taiga
```

Wait for the taiga and database pods to come up, then execute:

```console
$ kubectl port-forward service/taiga 8080:80
```

You will now be able to access your taiga instance at `http://localhost:8080`.

### Introduction

This chart bootstrap a [taiga](https://taiga.io/) Deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It provisions a basic taiga installation (taiga-events is not currently provisioned), which by default has no persistence, but can be configured to do so.

Check out the [official taiga website](https://taiga.io/) for informations on how to use and configure your installation.


## Prerequisites

- Kubernetes 1.10+
- Optionally, you can use your own pre-provisioned instance of PostgreSQL, for data storage. This chart provision a dedicated PostgreSQL database for you, by default.
- Optionally, you can rely on a dynamic PV provisioner, for the persistence of both the taiga and PostgreSQL data.


## Installing, uninstalling and configuring the Chart

To install the chart with the release name `my-taiga`:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-taiga --set taiga.dbHost=my-taiga-postgresql incubator/taiga
```

Note that the `taiga.dbHost` parameter must be consistent with the release name, when provisioning PostgreSQL.

To uninstall/delete the `my-taiga` release:

```console
$ helm delete my-taiga
```

Refer to the [Helm](https://www.helm.sh/) project documentation for more usage notes.


## Configuration parameters

The following table lists the configurable parameters of the taiga chart, and their default values. It also includes some useful options of the deployable PostgreSQL dependency, but any configuration valid for the `stable/postgresql` chart can be used.

Parameter | Description | Default
--- | --- | ---
`image.repository` | Taiga image repository. | `mvitale1989/docker-taiga`
`image.tag` | Taiga image tag. | `"20180818"`
`image.initRepository` | Init image repository. | `alpine`
`image.initTag` | Init image tag. | `3.7`
`image.pullPolicy` | Pull policy for both taiga and init images. | `IfNotPresent`
`service.type` | Service type for the taiga service. | `ClusterIP`
`service.port` | Service port for the taiga service. | `80`
`ingress.enabled` | Whether to enable the ingress resource for the taiga service, or not. | `false`
`ingress.annotations` | Annotations for the ingress resource, if enabled. Useful e.g. for configuring automatic certificate provisioning. | `{}`
`ingress.hosts` | List of hostnames which will expose this taiga service. | `[ "chart-example.local" ]`
`ingress.tls` | TLS configuration for the ingress object | `[]`
`resources` | Limits/requests for the taiga Pod object | `{}`
`nodeSelector` | Node selector for the taiga Pod object | `{}`
`tolerations` | Tolerations for the taiga Pod object | `[]`
`affinity` | Affinity map for the taiga Pod object | `{}`
`extraLabels` | Extra labels for all objects of a release | `{}`
`taiga.apiserver` | The name on which the taiga backend server will be accessible to *all* clients. See F.A.Q. for more informations | `localhost:8080`
`taiga.behindTlsProxy` | Whether taiga is behind a TLS termination; if using a TLS ingress, set this to true | `false`
`taiga.dbHost` | PostgreSQL database host to use. **IMPORTANT**: set to `${release_name}-postgresql` if provisioning PostgreSQL | `taiga-postgresql`
`taiga.dbName` | Name of PostgreSQL database to use | `taiga`
`taiga.dbUser` | Username to use for PostgreSQL authentication | `taiga`
`taiga.dbPassword` | Password to use for PostgreSQL authentication | `"changeme"`
`taiga.emailEnabled` | Enable taiga email. If enabled, all other email parameters must also be set | `false`
`taiga.emailFrom` | Value to use in the `From` header of the email. Not always honored | `""`, which defaults to `taiga@example.com`
`taiga.emailUseTls` | Use TLS for SMTP communications | `""`, which defaults to `true`
`taiga.emailSmtpHost` | SMTP host | `""`
`taiga.emailSmtpPort` | SMTP port | `""`, which defaults to 587
`taiga.emailSmtpUser` | SMTP username | `""`
`taiga.emailSmtpPassword` | SMTP password  | `""`
`taiga.secretKey` | taiga backend's secret key | `""`, which defaults to a 10 character random string
`persistence.deployPostgres` | Deploy a PostgreSQL instance, along with taiga; configure with the `postgresql` parameter. **IMPORTANT**: see note on the `taiga.dbHost` parameter. | `true`
`persistence.enabled` | Create a PVC for persistent storage of the taiga media directory. | `true`
`persistence.size` | Size of the volume requested by the PVC. | `8Gi`
`persistence.accessMode` | Access mode for the volume requested by the PVC. | `ReadWriteOnce`
`persistence.annotations` | Annotations to use in the PVC of the taiga pod. | `{}`
`persistence.storageClass` | Storage class of the PVC of the taiga pod. Use empty string for synamic provisioning. | `""`
`persistence.existingClaim` | Name of the pre-provisioned PVC to use, for taiga persistence; setting this overrides the creation of the PVC. `persistence.enabled` must be true. | `""`
`postgresql` | Configuration parameters for the provisioned PostgreSQL instance, if enabled. See the [PostgreSQL chart](https://github.com/helm/charts/tree/master/stable/postgresql) for details. | See parameters below
`postgresql.postgresUser` | Username to create in the provisioned PostgreSQL instance. | `"taiga"`
`postgresql.postgresPassword` | Password to configure for the provisioned PostgreSQL user. | `"changeme"`
`postgresql.postgresDatabase` | Database to create in the provisioned PostgreSQL instance. | `"taiga"`
`postgresql.persistence.enabled` | Create the PVC for the PostgreSQL instance. | `true`
`postgresql.persistence.size` | Size of the PostgreSQL data volume requested by the PVC. | `2Gi`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`, or in alternative, persist them inside of a YAML file, which you can then reference during installs/upgrades by using the `-f ./values.yaml` flag.

### Persistence

By default, this chart deploys both a taiga API server and a PostgreSQL database instance, generating the following PVCs:
* An `8Gi` volume dedicated to the taiga media directory
* A `2Gi` volume for PostgreSQL storage

You can tune the parameters associated with these volumes, or also choose to rely on already existing volumes instead, by using the `persistence` and `postgresql.persistence` parameters.

By default, no storage class is set for these PVCs, so the default dynamic volume provisioner is expected to create the corresponding PV. But you can optionally declare a storageClass name to use, if you prefer.

#### Using an External Database

If needed, you can choose to use an existing PostgreSQL instance instead of provisioning one, by disabling the `persistence.deployPostgres` parameter, and setting the `taiga.db*` parameters with the correct address and credentials.


## F.A.Q.

1. **Why do i need to explicitly specify `taiga.apiserver` and `taiga.behindTlsProxy`?** The taiga frontend will need this information, to generate the URLs used for reaching the taiga backend API server (respectively for the host/port and scheme part of the URL). This chart provisions both frontend and backend under the same service, and thus behind the same host/port and scheme, but in the general case the frontend wouldn't know how to find the API server if you didn't specify it in those parameters, as they may be deployed separately.
2. **Why do all web clients need to be able to reach what i specified in `taiga.apiserver`?** As mentioned in question 1, the frontend will use those parameters to generate the URLs pointing to the API server. This means that no matter what name you type in your browser to reach the frontend: the web client will attempt to reach the API server backend based on the `taiga.apiserver` and `taiga.behindTlsProxy` parameters. Note that despite this, you _can_ still connect to the frontend in any way you prefer (public name, `kubectl port-forward`, etc): just make sure it's also reachable through the name specified in the `taiga.apiserver` parameter.
3. **Can i configure multiple instances of taiga behind the same name, but with different paths?** No, path multiplexing is currenty not supported.


## Full example configuration

The following configuration is an example that produces a taiga installation, satisfying the following requirements:
- Taiga instance is publicly available, through an ingress controller (requires manual deployment and configuration of an ingress controller on the cluster, e.g. [ingress-nginx](https://github.com/kubernetes/ingress-nginx))
- Automatic provisioning of [letsencrypt](https://letsencrypt.org/) TLS certificates (requires manual deployment and configuration of [cert-manager](https://github.com/jetstack/cert-manager) or equivalent)
- Persistence for both taiga media files and PostgreSQL database (requires manual deployment of a dynamic volume provisioner, e.g. [rbd-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/ceph/rbd))
- Keep the PVCs, when deleting the taiga release.

```yaml
ingress:
  enabled: true
  annotations:
    kubernetes.io/tls-acme: "true"
  hosts:
  - taiga.mycompany.com
  tls:
  - secretName: tls-taiga
    hosts:
    - taiga.mycompany.com

taiga:
  apiserver: taiga.mycompany.com
  behindTlsProxy: true
  dbHost: my-taiga-postgresql
  dbName: taiga
  dbUser: taiga
  dbPassword: verySecureDatabasePassword
  emailEnabled: true
  emailFrom: taiga@mycompany.com
  emailSmtpHost: smtp.gmail.com
  emailSmtpUser: smtp-user@mycompany.com
  emailSmtpPassword: verySecureSmtpPassword
  secretKey: verySecureSecretKey

persistence:
  deployPostgres: true
  enabled: true
  size: 50Gi
  annotations:
    "helm.sh/resource-policy": keep

postgresql:
  postgresPassword: verySecureDatabasePassword
  persistence:
    enabled: true
    size: 8Gi
  annotations:
    "helm.sh/resource-policy": keep
  networkPolicy:
    enabled: false
```

Save the above in the `values.yaml` file, and then deploy your taiga instance on the cluster by executing the following:

```console
### Note: release name is relevant, and must be consistent with the `taiga.dbHost` parameter when provisioning the PostgreSQL database.
$ helm install -f values.yaml -n my-taiga incubator/taiga
```

After everything's been initialized, you will be able to access your taiga instance at `https://taiga.mycompany.com`.

Be sure to configure a DNS record `taiga.mycompany.com`, pointing to your ingress controller.
