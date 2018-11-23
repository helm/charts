# prometheus-operator hacks

## [sync_prometheus_rules.py](sync_prometheus_rules.py)

This script generates prometheus rules set for alertmanager based from any properly formatted kubernetes yaml based on defined input, splitting rules to separate files based on group name.

Currently only following imported:
 - [coreos/prometheus-operator rules set](https://github.com/coreos/prometheus-operator/blob/master/contrib/kube-prometheus/manifests/prometheus-rules.yaml)
 - [etcd-io/etc rules set](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/etcd3_alert.rules.yml) (temporary disabled)

## Grafana dashboards

Currently there is no script to import dashboards, they can be synced only manually.