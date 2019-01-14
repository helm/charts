# prometheus-operator hacks

## [sync_prometheus_rules.py](sync_prometheus_rules.py)

This script generates prometheus rules set for alertmanager from any properly formatted kubernetes yaml based on defined input, splitting rules to separate files based on group name.

Currently following imported:
 - [coreos/prometheus-operator rules set](https://github.com/coreos/prometheus-operator/blob/master/contrib/kube-prometheus/manifests/prometheus-rules.yaml)
 - [etcd-io/etc rules set](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/etcd3_alert.rules.yml) (temporary disabled)

## [sync_grafana_dashboards.py](sync_grafana_dashboards.py)

This script generates grafana dashboards from json files, splitting them to separate files based on group name.

Currently following imported:
 - [coreos/prometheus-operator dashboards](https://github.com/coreos/prometheus-operator/blob/master/contrib/kube-prometheus/manifests/grafana-deployment.yaml)
 - [etcd-io/etc dashboard](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/grafana.json)
 - [coreos/prometheus-operator CoreDNS dashboard](https://github.com/helm/charts/blob/master/stable/prometheus-operator/dashboards/grafana-coredns-k8s.json) (not maintained in this location)