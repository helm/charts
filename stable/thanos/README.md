# Thanos components

[Thanos](https://github.com/improbable-eng/thanos), a Thanos is a set of components that can be composed into a highly available metric system with unlimited storage capacity, which can be added seamlessly on top of existing Prometheus deployments.

## TL;DR;
Replace all the `thanos-chart-test` with existing buckets
Set all the creds for buckets in `.Values.ruleLayer.secret.google`, `.Values.storeLayer.secret.google`, `.Values.compactLayer.secret.google`
```console
$ helm install stable/thanos-components -f values.yaml
```

## TODO

* Add all the storages (only GCS is supported atm)
## Introduction

This chart bootstraps the next [Thanos](https://github.com/improbable-eng/thanos) components' deployments on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager:

* [Query](https://github.com/improbable-eng/thanos/blob/master/docs/components/query.md)
* [Rulre](https://github.com/improbable-eng/thanos/blob/master/docs/components/Rulre.md)
* [Store](https://github.com/improbable-eng/thanos/blob/master/docs/components/store.md)
* [Compact](https://github.com/improbable-eng/thanos/blob/master/docs/components/compact.md)

Note, that deploying Prometheus + sidecar is out of concern of this helm chart, check [this example](https://github.com/improbable-eng/thanos/tree/master/tutorials/kubernetes-helm) to see how it might be done with official [Prometheus helm chart](https://github.com/helm/charts/tree/master/stable/prometheus).
## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/thanos-components
```

The command deploys mentioned above Thanos components on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Thanos active development

[Thanos](https://github.com/improbable-eng/thanos) project itself is under very active development.

Look closely to versions you deploy and changelog of Thanos to avoid outages and data corruptions.

## Configuration
TODO: describe data dir choices
TODO: Explain wtf is going on with sidecar values

### Compactor

Special notes:

* By default Compactor uses `emptyDir` volume defined in `extraEmptyDirMounts` for data. Set `extraEmptyDirMounts` to '' and define `persistence` to change it to PV
* `replicas: 1` hardcoded in the template because it's dangerous for data consistency to have more than one replica of Compactor.
* !! Compactor is not going to work properly without provided credentials for the storage !!
* There are certain keys reserved for `compactLayer.secret`:
  *  `compactLayer.secret.google` - use this for SA if you have GCS storage, have to be passed base64 encoded.
  * TODO: Support all the other storages

Parameter | Description | Default
--------- | ----------- | -------
`compactLayer.binaryArgs` | List of args that have to be passed to the `thanos compact` command | check out in `values.yaml`
`compactLayer.name` | Used for labels and label selectors | `compact`
`compactLayer.configMap.data` | Snippet (dictionary) of `key: value` pairs to fill the `configMap` with | check out `values.yaml`
`compactLayer.configMap.mountPath` | Path for mounting the `configMap` | `/etc/thanos-compact/`
`compactLayer.configMap.name` | Name of the compactor `configMap` | `config`
`compactLayer.persistence.enabled` | If true - creates PVC for data | `false`
`compactLayer.persistence.mountPath ` | Where to mount PV created by PVC inside the container | `""`
`compactLayer.persistence.size` | Size of the PVC | `""`
`compactLayer.persistence.storageClassName` | storageClassName for the PVC | `""`
`compactLayer.enabled` | If true, create compactor POD | `true`
`compactLayer.extraEmptyDirMounts[].mountPath` | Path for mounting an extra `emptyDir` mount | `/thanos-compact-data/`
`compactLayer.extraEmptyDirMounts[].name` | Name of extra `emptyDir` mount | `data`
`compactLayer.image.pullPolicy` | Compactor container image pull policy | `IfNotPresent`
`compactLayer.image.repository` | Compactor container image repository | `improbable/thanos`
`compactLayer.image.tag` | Compactor container image tag | `v0.3.2`
`compactLayer.labels` | Dictionary of labels assigned to every entity created along with Compactor | `{env: "test", app: "thanos", component: "compactor"}`
`compactLayer.nodeSelector`| Snippet (dictionary) of `key: value` pairs for `.spec.template.spec.nodeSelector` | `{}`
`compactLayer.podAnnotations` | Snippet (dictionary) of `key: value` pairs for `.spec.template.metadata.annotations` | `{}`
`compactLayer.priorityClassName` | Compactor `priorityClassName` | `""`
`compactLayer.resources` | Snippet with container resources definition | check out `values.yaml`
`compactLayer.schedulerName` | Compactor alternate scheduler name | `""`
`compactLayer.secret` | Snippet (dictionary) of `key: value` pairs for `Secret`. `value` has to be b64 encoded. Read "Special Notes" | check out `values.yaml`
`compactLayer.securityContext` | Compactor `securityContext` | ""
`compactLayer.statefulSetAnnotations` | Snippet (dictionary) of `key: value` pairs for `.metadata.annotations` | `{}`
`compactLayer.terminationGracePeriodSeconds` | Compactor Pod termination grace period | `15`
`compactLayer.tolerations` | Snippet (list) of Compactor Pod tolerations | `[]`

### ingress

Special notes:

* Ingress is not any critical component of a system, but you might want to deploy it for ease of human access

Parameter | Description | Default
--------- | ----------- | -------
`ingress.annotations` | Snippet (dictionary) of `key: value` pairs for `.metadata.annotations` | `{}`
`ingress.name` | Used for labels and label selectors | `common`
`ingress.enabled` | If true - deploys ingress with possible Ruler and Query as backends | `false`
`ingress.host` | Hostname to server on | `''`
`ingress.query.path` | URI that should lead to Query UI | `''`
`ingress.ruler.path` | URI that should lead to Ruler UI | `''`
`ingress.tls[]` | Snippet (list) of TLS ingress configs | `[]`

### Query

Special notes:

* Query Layer application exposes two APIs inside a single container: `Store` API and `Query` API. Store API is a GRPC service, and Query is a HTTP. That's why we configure two `Services` here.

Parameter | Description | Default
--------- | ----------- | -------
`queryLayer.binaryArgs` | List of args that have to be passed to the `thanos query` command | check out in `values.yaml`
`queryLayer.name` | Used for labels and label selectors | `query`
`queryLayer.deploymentAnnotations` | Snippet (dictionary) of `key: value` pairs for `.metadata.annotations` | `{}`
`queryLayer.enabled` | If true, create query POD | `true`
`queryLayer.image.pullPolicy` | Query container image pull policy | `IfNotPresent`
`queryLayer.image.repository` | Query container image repository | `improbable/thanos`
`queryLayer.image.tag` | Query container image tag | `v0.3.2`
`queryLayer.labels` | Dictionary of labels assigned to every entity created along with Query layer | `{env: "test", app: "thanos", component: "query"}`
`queryLayer.name` | Part of the name for some components, helps to make keep them unique | `query-layer`
`queryLayer.nodeSelector` | Snippet (dictionary) of `key: value` pairs for `.spec.template.spec.nodeSelector` | `{}`
`queryLayer.podAnnotations` | Snippet (dictionary) of `key: value` pairs for `.spec.template.metadata.annotations` | `{}`
-`queryLayer.pointToLocalRulers` | Make rulers deployed with the same chart a target for this queryLayer. Implies `--store=` parameter. | `true`
`queryLayer.pointToLocalSidecars` | Make a query svc deployed with the same chart a target for this queryLayer. Implies `--store=` parameter. | `true`
`queryLayer.priorityClassName` | Query `priorityClassName` | `""`
`queryLayer.queryApiService.annotations` | Snippet (dict) of annotations for `metadata.annotations` of a Service | `{prometheus.io/scrape: 'false'}`
`queryLayer.queryApiService.clusterIP` | `ClusterIP` of a Query API `service` of a query | `None` (headless)
`queryLayer.queryApiService.enabled` | Enable creation of a `Service` for a query pods (Query API) | check out in `values.yaml`
`queryLayer.queryApiService.externalIPs` | List of `externalIPs` of a Query API `service` of a query | `[]`
`queryLayer.queryApiService.loadBalancerIP` | `loadBalancerIP`  of a Query API `service` of a query | `""`
`queryLayer.queryApiService.loadBalancerSourceRanges` | `loadBalancerSourceRanges` of a Query API `service` of a query | `""`
`queryLayer.queryApiService.nodePort` | `nodePort` of a Query API `service` of a query | `""`
`queryLayer.queryApiService.selector` | Snippet (dict) of labels for `.spec.selector` of a service | `[]`
`queryLayer.queryApiService.servicePort` | `servicePort` of a Query API `service` of a query | `"9090"`
`queryLayer.queryApiService.type` | `type` of a Query API `service` of a query | `"LoadBalancer"`
`queryLayer.replicaCount` | Number of Query PODs to run  | `"3"`
`queryLayer.resources` | Snippet with container resources definition | check out `values.yaml`
`queryLayer.schedulerName` | Query layer alternate scheduler name | `""`
`queryLayer.securityContext` | Query layer `securityContext` | ""
`queryLayer.storeApiService.annotations` | Snippet (dict) of annotations for `metadata.annotations` of a Service | `{prometheus.io/scrape: 'false'}`
`queryLayer.storeApiService.clusterIP` | `ClusterIP` of a Store API `service` of a query | `None` (headless)
`queryLayer.storeApiService.enabled` | Enable creation of a `Service` for a query pods (Store API) | check out in `values.yaml`
`queryLayer.storeApiService.externalIPs` | List of `externalIPs` of a Store API `service` of a query | `[]`
`queryLayer.storeApiService.loadBalancerIP` | `loadBalancerIP`  of a Store API `service` of a query | `""`
`queryLayer.storeApiService.loadBalancerSourceRanges` | `loadBalancerSourceRanges` of a Store API `service` of a query | `""`
`queryLayer.storeApiService.nodePort` | `nodePort` of a Store API `service` of a query | `""`
`queryLayer.storeApiService.selector` | Snippet (dict) of labels for `.spec.selector` of a service | `[]`
`queryLayer.storeApiService.servicePort` | `servicePort` of a Store API `service` of a query | `"10901"`
`queryLayer.storeApiService.type` | `type` of a Store API `service` of a query | `"LoadBalancer"`
`queryLayer.strategy` | Query layer rolling update strategy (snippet) | {}
`queryLayer.terminationGracePeriodSeconds` | Query layer Pod termination grace period | `15`
`queryLayer.tolerations` | Snippet (list) of Query Pod tolerations | `[]`

### Rule

* !! Rule is not going to work properly without provided credentials for the storage !!
* There are certain keys reserved for `compactLayer.secret`:
  *  `compactLayer.secret.google` - use this for SA if you have GCS storage, have to be passed base64 encoded.
  * TODO: Support all the other storages


Parameter | Description | Default
--------- | ----------- | -------
`ruleLayer.RuleUiServicre.annotations` | Snippet (dict) of annotations for `metadata.annotations` of a Service | `{prometheus.io/scrape: 'false'}`
`ruleLayer.RuleUiServicre.clusterIP` | `ClusterIP` of a Store API `service` of a Ruler | `None` (headless)
`ruleLayer.RuleUiServicre.enabled` | Enable creation of a `Service` for a Ruler pods | check out in `values.yaml`
`ruleLayer.RuleUiServicre.externalIPs` | List of `externalIPs` of a Store API `service` of a Ruler | `[]`
`ruleLayer.RuleUiServicre.loadBalancerIP` | `loadBalancerIP`  of a Store API `service` of a Ruler | `""`
`ruleLayer.RuleUiServicre.loadBalancerSourceRanges` | `loadBalancerSourceRanges` of a Store API `service` of a Ruler | `""`
`ruleLayer.RuleUiServicre.nodePort` | `nodePort` of a Store API `service` of a Ruler | `""`
`ruleLayer.RuleUiServicre.selector` | Snippet (dict) of labels for `.spec.selector` of a service | `[]`
`ruleLayer.RuleUiServicre.servicePort` | `servicePort` of a Store API `service` of a Ruler | `"10902"`
`ruleLayer.RuleUiServicre.type` | `type` of a Store API `service` of a Ruler | `"LoadBalancer"`
`ruleLayer.rules` | Array of groups with alerting/recording rules | `{env: "test", app: "thanos", component: "Rulre"}`
`ruleLayer.persistence.accessModes` | accessMode for PVC tempalte | `['ReadWriteOnce']`
`ruleLayer.persistence.enabled` | Enables and disables persistance for rule Layer | `true`
`ruleLayer.persistence.mountPath` | MountPath for persistance volume | `/thanos-rule-persistent-data/`
`ruleLayer.persistence.storageClass` | Storageclass for PVC template | `standard`
`ruleLayer.persistence.size` | size for PVC template | `50Gi`
`ruleLayer.alerting` | Array of groups with alerting Rulesr | `{env: "test", app: "thanos", component: "Rulre"}`
`ruleLayer.binaryArgs` | List of args that have to be passed to the `thanos Rulre` command | check out in `values.yaml`
`ruleLayer.name` | Used for labels and label selectors | `rule`
`ruleLayer.configMap.data` | Snippet (dictionary) of `key: value` pairs to fill the `configMap` with | check out `values.yaml`
`ruleLayer.configMap.mountPath` | Path for mounting the `configMap` | `/etc/thanos-Rulre/`
`ruleLayer.configMap.name` | Name of the Ruler `configMap` | `config`
`ruleLayer.deploymentAnnotations` | Snippet (dictionary) of `key: value` pairs for `.metadata.annotations` | `{}`
`ruleLayer.enabled` | If true, create Ruler POD | `true`
`ruleLayer.extraEmptyDirMounts[].mountPath` | Path for mounting an extra `emptyDir` mount | `/thanos-rule-data/`
`ruleLayer.extraEmptyDirMounts[].name` | Name of extra `emptyDir` mount | `data`
`ruleLayer.image.pullPolicy` | Ruler container image pull policy | `IfNotPresent`
`ruleLayer.image.repository` | Ruler container image repository | `improbable/thanos`
`ruleLayer.image.tag` | Ruler container image tag | `v0.3.2`
`ruleLayer.labels` | Dictionary of labels assigned to every entity created along with Ruler | `{env: "test", app: "thanos", component: "Rulre"}`
`ruleLayer.nodeSelector`| Snippet (dictionary) of `key: value` pairs for `.spec.template.spec.nodeSelector` | `{}`
`ruleLayer.podAnnotations` | Snippet (dictionary) of `key: value` pairs for `.spec.template.metadata.annotations` | `{}`
`ruleLayer.pointToLocalQuery.enabled` | If true - implies `--query` binary arg with a value of address local to this Release queryLayer `Service` | `true`
`ruleLayer.pointToLocalQuery.uri` | Use if `web.route-prefix` or `web.external-prefix` were passed to the target query layer | `''`
`ruleLayer.priorityClassName` | Ruler `priorityClassName` | `""`
`ruleLayer.replicaCount` | Number of Query PODs to run  | `"3"`
`ruleLayer.resources` | Snippet with container resources definition | check out `values.yaml`
`ruleLayer.schedulerName` | Ruler alternate scheduler name | `""`
`compactLayer.secret` | Snippet (dictionary) of `key: value` pairs for `Secret`. `value` has to be b64 encoded. Read "Special Notes" | check out `values.yaml`
`ruleLayer.securityContext` | Ruler `securityContext` | `""`
`ruleLayer.strategy` | Ruler rolling update strategy (snippet) | `{}`
`ruleLayer.terminationGracePeriodSeconds` | Ruler Pod termination grace period | `15`
`ruleLayer.tolerations` | Snippet (list) of Ruler Pod tolerations | `[]`

### Sidecar

Special Notes:

* Sidecar component isn't being deployed with this helm Chart, it is recommended to use official Prometheus helm chart to do so. Here we only configure a service that would have sidecars as backends to point Queries to it. All we need to know is right selector labels for Prometheus+sidecar PODs

Parameter | Description | Default
--------- | ----------- | -------
`sidecarLayer.name` | Used for labels and label selectors | `sidecar`
`sidecarLayer.storeApiService.annotations` | Snippet (dict) of annotations for `metadata.annotations` of a Service | `{prometheus.io/scrape: 'false'}`
`sidecarLayer.storeApiService.clusterIP` | `ClusterIP` of a Store API `service` of a sidecar | `None` (headless)
`sidecarLayer.storeApiService.enabled` | Enable creation of a `Service` for a sidecar pods | `false`
`sidecarLayer.storeApiService.externalIPs` | List of `externalIPs` of a Store API `service` of a sidecar | `[]`
`sidecarLayer.storeApiService.loadBalancerIP` | `loadBalancerIP`  of a Store API `service` of a sidecar | `""`
`sidecarLayer.storeApiService.loadBalancerSourceRanges` | `loadBalancerSourceRanges` of a Store API `service` of a sidecar | `""`
`sidecarLayer.storeApiService.nodePort` | `nodePort` of a Store API `service` of a sidecar | `""`
`sidecarLayer.storeApiService.selector` | Snippet (dict) of labels for `.spec.selector` of a service | `[]`
`sidecarLayer.storeApiService.servicePort` | `servicePort` of a Store API `service` of a sidecar | `"10901"`
`sidecarLayer.storeApiService.type` | `type` of a Store API `service` of a sidecar | `"ClusterIP"`

### Store

Special notes:

* By default Store uses `emptyDir` volume defined in `extraEmptyDirMounts` for data. Set `extraEmptyDirMounts` to '' and define `persistence` to change it to PV
* !! Store is going to CrashLoopBackOff without provided credentials for the storage !!
* There are certain keys reserved for `compactLayer.secret`:
  *  `compactLayer.secret.google` - use this for SA if you have GCS storage, have to be passed base64 encoded.
  * TODO: Support all the other storages


Parameter | Description | Default
--------- | ----------- | -------
`storeLayer.binaryArgs` | List of args that have to be passed to the `thanos store` command | check out in `values.yaml`
`storeLayer.name` | Used for labels and label selectors | `store`
`storeLayer.configMap.data` | Snippet (dictionary) of `key: value` pairs to fill the `configMap` with | check out `values.yaml`
`storeLayer.configMap.mountPath` | Path for mounting the `configMap` | `/etc/thanos-store/`
`storeLayer.configMap.name` | Name of the store `configMap` | `config`
`storeLayer.persistence.enabled` | If true - creates PVC for data | `false`
`storeLayer.persistence.mountPath ` | Where to mount PV created by PVC inside the container | `""`
`storeLayer.persistence.size` | Size of the PVC | `""`
`storeLayer.persistence.storageClassName` | storageClassName for the PVC | `""`
`storeLayer.enabled` | If true, create store POD | `true`
`storeLayer.extraEmptyDirMounts[].mountPath` | Path for mounting an extra `emptyDir` mount | `/thanos-store-data/`
`storeLayer.extraEmptyDirMounts[].name` | Name of extra `emptyDir` mount | `data`
`storeLayer.extraEmptyDirMounts[].name` | Name of extra `emptyDir` mount | `data`
`storeLayer.image.pullPolicy` | Store container image pull policy | `IfNotPresent`
`storeLayer.image.repository` | Store container image repository | `improbable/thanos`
`storeLayer.image.tag` | Store container image tag | `v0.3.2`
`storeLayer.labels` | Dictionary of labels assigned to every entity created along with Store layer | `{env: "test", app: "thanos", component: "store"}`
`storeLayer.name` | Part of the name for some components, helps to make keep them unique | `query-layer`
`storeLayer.nodeSelector`| Snippet (dictionary) of `key: value` pairs for `.spec.template.spec.nodeSelector` | `{}`
`storeLayer.podAnnotations` | Snippet (dictionary) of `key: value` pairs for `.spec.template.metadata.annotations` | `{}`
`storeLayer.priorityClassName` | Store `priorityClassName` | `""`
`storeLayer.replicaCount` | Number of Store PODs to run  | `"2"`
`storeLayer.resources` | Snippet with container resources definition | check out `values.yaml`
`storeLayer.schedulerName` | Store alternate scheduler name | `""`
`compactLayer.secret` | Snippet (dictionary) of `key: value` pairs for `Secret`. `value` has to be b64 encoded. Read "Special Notes" | check out `values.yaml`
`storeLayer.securityContext` | Store `securityContext` | ""
`storeLayer.statefulSetAnnotations` | Snippet (dictionary) of `key: value` pairs for `.metadata.annotations` | `{}`
`storeLayer.storeApiService.annotations` | Snippet (dict) of annotations for `metadata.annotations` of a Service | `{prometheus.io/scrape: 'false'}`
`storeLayer.storeApiService.clusterIP` | `ClusterIP` of a Store API `service` of a Store layer | `None` (headless)
`storeLayer.storeApiService.enabled` | Enable creation of a `Service` for a store pods | check out in `values.yaml`
`storeLayer.storeApiService.externalIPs` | List of `externalIPs` of a Store API `service` of a Store layer | `[]`
`storeLayer.storeApiService.loadBalancerIP` | `loadBalancerIP`  of a Store API `service` of a Store layer | `""`
`storeLayer.storeApiService.loadBalancerSourceRanges` | `loadBalancerSourceRanges` of a Store API `service` of a Store layer | `""`
`storeLayer.storeApiService.nodePort` | `nodePort` of a Store API `service` of a Store layer | `""`
`storeLayer.storeApiService.selector` | Snippet (dict) of labels for `.spec.selector` of a service | `[]`
`storeLayer.storeApiService.servicePort` | `servicePort` of a Store API `service` of a Store layer | `"10901"`
`storeLayer.storeApiService.type` | `type` of a Store API `service` of a Store layer | `"ClusterIP"`
`storeLayer.terminationGracePeriodSeconds` | Store Pod termination grace period | `15`
`storeLayer.tolerations` | Snippet (list) of Store Pod tolerations | `[]`


You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install` or using `Values` file. Please, find more detailed description in official Helm documentation.
