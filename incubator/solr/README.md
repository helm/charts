# Solr Helm Chart

This helm chart installs a Solr cluster and its required Zookeeper cluster into a running
kubernetes cluster.

The chart installs the Solr docker image from: https://hub.docker.com/_/solr/

## Dependencies

- The zookeeper incubator helm chart
- Tested on kubernetes 1.10+

## Installation

To install the Solr helm chart run:

```txt
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install --name solr incubator/solr
```

## Configuration Options

The following table shows the configuration options for the Solr helm chart:

| Parameter                                     | Description                           | Default Value                                                       |
| --------------------------------------------- | ------------------------------------- | --------------------------------------------------------------------- |
| `global.imagePullSecrets`                     | Global Docker registry secret names as an array       | `[]` (does not add image pull secrets to deployed pods)      |
| `port`                                        | The port that Solr will listen on | `8983`                                                                |
| `replicaCount`                                | The number of replicas in the Solr statefulset | `3`                                                                   |
| `javaMem`                                     | JVM memory settings to pass to Solr | `-Xms2g -Xmx3g`                                                       |
| `resources`                                   | Resource limits and requests to set on the solr pods | `{}` |
| `extraEnvVars`                                | Additional environment variables to set on the solr pods (in yaml syntax) | `[]` |
| `initScript`                                | The file name of the custom script to be run before starting Solr | `""` |

| `terminationGracePeriodSeconds`               | The termination grace period of the Solr pods | `180`|
| `image.repository`                            | The repository to pull the docker image from| `solr`                                                                |
| `image.tag`                                   | The tag on the repository to pull | `7.7.2`                                                               |
| `image.pullPolicy`                            | Solr pod pullPolicy | `IfNotPresent`                                                              |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array      | `[]` (does not add image pull secrets to deployed pods)      |
| `livenessProbe.initialDelaySeconds`           | Initial Delay for Solr pod liveness probe | `20`                                                                  |
| `livenessProbe.periodSeconds`                 | Poll rate for liveness probe | `10`                                                                  |
| `readinessProbe.initialDelaySeconds`          | Initial Delay for Solr pod readiness probe | `15`                                                                  |
| `readinessProbe.periodSeconds`                | Poll rate for readiness probe | `5`                                                                   |
| `podAnnotations`                              | Annotations to be applied to the solr pods | `{}` |
| `affinity`                                    | Affinity policy to be applied to the Solr pods | `{}` |
| `updateStrategy`                              | The update strategy of the solr pods | `{}` |
| `logLevel`                                    | The log level of the solr pods  | `INFO` |
| `podDisruptionBudget`                         | The pod disruption budget for the Solr statefulset | `{"maxUnavailable": 1}`                                                                   |
| `schedulerName`                               | The name of the k8s scheduler (other than default)  | ` nil`       |
| `volumeClaimTemplates.storageClassName`       | The name of the storage class for the Solr PVC | ``                                                             |
| `volumeClaimTemplates.storageSize`            | The size of the PVC | `20Gi`                                                                |
| `volumeClaimTemplates.accessModes`            | The access mode of the PVC| `[ "ReadWriteOnce" ]`                                                       |
| `tls.enabled`                                 | Whether to enable TLS, requires `tls.certSecret.name` to be set to a secret containing cert details, see README for details           | `false`                                                               |
| `tls.wantClientAuth`                          | Whether Solr wants client authentication | `false`                                                               |
| `tls.needClientAuth`                          | Whether Solr requires client authentication | `false`                                                               |
| `tls.keystorePassword`                        | Password for the tls java keystore | `changeit`                                                            |
| `tls.importKubernetesCA`                      | Whether to import the kubernetes CA into the Solr truststore | `false`                                                               |
| `tls.checkPeerName`                           | Whether Solr checks the name in the TLS certs | `false`                                                               |
| `tls.caSecret.name`                           | The name of the Kubernetes secret containing the ca bunble to import into the truststore | ``                                                                    |
| `tls.caSecret.bundlePath`                     | The key in the Kubernetes secret that contains the CA bundle | ``                                                                    |
| `tls.certSecret.name`                         | The name of the Kubernetes secret that contains the TLS certificate and private key | ``                                                                    |
| `tls.certSecret.keyPath`                      | The key in the Kubernetes secret that contains the private key | `tls.key`                                                             |
| `tls.certSecret.certPath`                     | The key in the Kubernetes secret that contains the TLS certificate | `tls.crt`                                                             |
| `service.type`                                | The type of service for the solr client service | `ClusterIP`                                                           |
| `service.annotations`                         | Annotations to apply to the solr client service | `{}` |
| `exporter.enabled`                            | Whether to enable the Solr Prometheus exporter | `false`                                                               |
| `exporter.image.pullSecrets`                  | Specify docker-registry secret names as an array      | `[]` (does not add image pull secrets to deployed pods)      |
| `exporter.configFile`                         | The path in the docker image that the exporter loads the config from | `/opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml` |
| `exporter.updateStrategy`                     | Update strategy for the exporter deployment | `{}` |
| `exporter.podAnnotations`                     | Annotations to set on the exporter pods | `{}`
| `exporter.resources`                          | Resource limits to set on the exporter pods | `{}` |
| `exporter.port`                               | The port that the exporter runs on | `9983`                                                                |
| `exporter.threads`                            | The number of query threads that the exporter runs | `7`                                                                   |
| `exporter.livenessProbe.initialDelaySeconds`  | Initial Delay for the exporter pod liveness| `20`                                                                  |
| `exporter.livenessProbe.periodSeconds`        | Poll rate for liveness probe | `10`                                                                  |
| `exporter.readinessProbe.initialDelaySeconds` | Initial Delay for the exporter pod readiness | `15`                                                                  |
| `exporter.readinessProbe.periodSeconds`       | Poll rate for readiness probe | `5`                                                                   |
| `exporter.service.type`                       | The type of the exporter service | `ClusterIP`                                                           |
| `exporter.service.annotations`                | Annotations to apply to the exporter service | `{}` |

## Service Start with command sets

```sh
helm install --name solr \
    --set image.tag=7.7.2,javaMem="-Xms1g -Xmx1g",logLevel=INFO,replicaCount=2,livenessProbe.initialDelaySeconds=420,exporter.readinessProbe.periodSeconds=30 incubator/solr
```

## TLS Configuration

Solr can be configured to use TLS to encrypt the traffic between solr nodes. To set this up with a certificate signed by the Kubernetes CA:

Generate SSL certificate for the installation:

`cfssl genkey ssl_config.json | cfssljson -bare server`

base64 Encode the CSR and apply into kubernetes as a CertificateSigningRequest

```sh
export MY_CSR_NAME="solr-certifiate"
cat <<EOF | ikubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${MY_CSR_NAME}
spec:
  groups:
  - system:authenticated
  request: $(cat server.csr | base64 | tr -d '\n')
EOF

```

Approve the CSR

`kubectl certificate approve ${MY_CSR_NAME}`

We can now retrieve the approved certificate and save it to `server-cert.pem`

`kubectl get csr "${MY_CSR_NAME}" -o jsonpath='{.status.certificate}'   | base64 --decode  > server-cert.pem`

We store the certificate and private key in a Kubernetes secret:

`kubectl create secret tls solr-certificate --cert server-cert.pem --key server-key.pem`

Now the secret can be used in the solr installation:

`helm install  . --set tls.enabled=true,tls.certSecret.name=solr-certificate,tls.importKubernetesCA=true`

## Minikube Notes

- Chart out of the box start with 2G,2G...So..
- minikube start --vm-driver=hyperkit --memory 4096
- minikube start --vm-driver=virtualbox --memory 4096
