# dmarc2logstash Helm Chart

[dmarc2logstash](https://github.com/jertel/dmarc2logstash): A POP3 polling service that converts Domain-based Message Authentication, Reporting, and Complicane (DMARC) reports into a logstash feed. More information about the DMARC organization and RFC 7489 standards can be found at https://dmarc.org. An accompanying [dashboard](https://github.com/jertel/dmarc2logstash/blob/master/grafana-dashboard.json) is available for import into Grafana.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release stable/dmarc2logstash
```

The command deploys dmarc2logstash on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation. The [secrets](#secrets) section lists the required Kubernetes secrets.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

setting                           | description                                                                                                           | default
----------------------------------|-----------------------------------------------------------------------------------------------------------------------|----------
dmarc2logstash.image.repository   | dmarc2logstash Docker image repository                                                                                | jertel/dmarc2logstash
dmarc2logstash.image.tag          | dmarc2logstash image tag, typically the version, of the Docker image                                                  | 1.0.3
dmarc2logstash.image.pullPolicy   | dmarc2logstash Kubernetes image pull policy                                                                           | IfNotPresent
delete_messages                   | Set to 1 to delete messages or 0 to preserve messages (useful for debugging) | 1
filebeat.image.repository         | Elastic filebeat Docker image repository                                                                              | docker.elastic.co/beats/filebeat
filebeat.image.tag                | Elastic filebeat tag, typically the version, of the Docker image                                                      | 6.6.0
filebeat.image.pullPolicy         | Elastic filebeat Kubernetes image pull policy                                                                         | IfNotPresent
filebeat.logstash.host            | Logstash service host; ex: logstash (this value must be provided)                                                     | ""
filebeat.logstash.port            | Logstash service port                                                                                                 | 5000
filebeat.logstash.sourceType      | Logstash source type will allow custom filtering via the Logstash configuration                                       | json-logs
filebeat.logstash.index           | Elasticsearch index that will contain the new DMARC data (index will be created on-the-fly if doesn't exist)           | dmarc
filebeat.logstash.timeout         | Seconds to wait before timing out the connection to logstash                                                          | 15

## Secrets

The following dmarc2logstash-secrets are required to be present in order for this chart to deploy:

variable               | required | description
-----------------------|----------|------------
pop3_server            | true     | The POP3 server hostname or IP address (must support TLS)
pop3_username          | true     | POP3 account username
pop3_password          | true     | POP3 account password

Below is a sample secrets.yaml file that can be used as a template. Remember that all secrets must be base64-encoded.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: dmarc2logstash-secrets
type: Opaque
data:
  pop3_server: ""
  pop3_username: ""
  pop3_password: ""
```

Once you have provided the base64-encoded secret values, apply the file to your Kubernetes cluster as follows:

```console
kubectl apply -f secrets.yaml
```
