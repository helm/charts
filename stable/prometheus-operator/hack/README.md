# prometheus-operator hacks

## [sync_prometheus_rules.py](sync_prometheus_rules.py)

This script generates prometheus rules set for alertmanager from any properly formatted kubernetes yaml based on defined input, splitting rules to separate files based on group name.

Currently following imported:

- [coreos/kube-prometheus rules set](https://github.com/coreos/kube-prometheus/master/manifests/prometheus-rules.yaml)
  - In order to modify these rules:
    - prepare and merge PR into [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/rules)
    - run import inside your fork of [coreos/kube-prometheus](https://github.com/coreos/kube-prometheus/tree/master)

     ```bash
     jb update
     make generate-in-docker
     ```

    - prepare and merge PR with imported changes into coreos/kube-prometheus
    - run sync_prometheus_rules.py inside your fork of this repo
    - send PR with changes to this repo
- [etcd-io/etc rules set](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/etcd3_alert.rules.yml)
  - In order to modify these rules:
    - prepare and merge PR into [etcd-io/etcd](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/grafana.json) repo
    - run sync_prometheus_rules.py inside your fork of this repo
    - send PR with changes to this repo

## [sync_grafana_dashboards.py](sync_grafana_dashboards.py)

This script generates grafana dashboards from json files, splitting them to separate files based on group name.

Currently following imported:

- [coreos/kube-prometheus dashboards](https://github.com/coreos/kube-prometheus/manifests/grafana-deployment.yaml)
  - In order to modify these dashboards:
    - prepare and merge PR into [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/dashboards)
    - run import inside your fork of [coreos/kube-prometheus](https://github.com/coreos/kube-prometheus/tree/master)

     ```bash
     jb update
     make generate-in-docker
     ```

    - prepare and merge PR with imported changes into coreos/kube-prometheus
    - run sync_grafana_dashboards.py inside your fork of this repo
    - send PR with changes to this repo
- [etcd-io/etc dashboard](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/grafana.json)
  - In order to modify this dashboard:
    - prepare and merge PR into [etcd-io/etcd](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/grafana.json) repo
    - run sync_grafana_dashboards.py inside your fork of this repo
    - send PR with changes to this repo

[CoreDNS dashboard](https://github.com/helm/charts/blob/master/stable/prometheus-operator/templates/grafana/dashboards/k8s-coredns.yaml) is the only dashboard which is maintained in this repo and can be changed without import.
