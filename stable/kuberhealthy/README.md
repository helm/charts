<center><img src="https://github.com/Comcast/kuberhealthy/blob/master/images/kuberhealthy.png?raw=true"></center><br />

Easy synthetic testing for [Kubernetes](https://kubernetes.io) clusters.  Supplements other solutions like [Prometheus](https://prometheus.io/) nicely.

## What is Kuberhealthy?

Kuberhealthy performs stynthetic tests from within Kubernetes clusters in order to catch issues that would otherwise go unnoticed.  Instead of trying to identify all the things that could potentially go wrong, Kuberhealthy replicates real workflow and watches carefully for the expected Kubernetes behavior to occur.  Kuberhealthy serves both a JSON status page and a [Prometheus](https://prometheus.io/) metrics endpoint for integration into your choice of alerting solution.  More checks will be added in future versions to better cover [service provisioning](https://github.com/Comcast/kuberhealthy/issues/11), [DNS resolution](https://github.com/Comcast/kuberhealthy/issues/16), [disk provisioning](https://github.com/Comcast/kuberhealthy/issues/9), and more.

Some examples of errors Kuberhealthy would detect:

- Pods stuck in `Terminating` due to CNI communication failures
- Pods stuck in `ContainerCreating` due to disk scheduler errors
- Pods stuck in `Pending` due to Docker daemon errors
- A node that can not provision or terminate pods for any reason
- A pod in the `kube-system` namespace that is restarting too quickly
- A cluster component that is in a non-ready state
- Intermittent failures to access or create custom resources
- Kubernetes system services remaining technically "healthy" while their underlying pods are crashing
  - kue-scheduler
  - kube-apiserver
  - kube-dns

#### Deployment and Status Page

Deploying Kuberhealthy is as simple as applying the [helm](https://helm.sh/) chart file in this repository:

```
cd helm
helm install .
```

##### Status Page

If you choose to alert from the JSON status page, you can access the status on `http://kuberhealthy.kuberhealthy.svc.cluster.local`.  The status page displays server status in the format shown below.  The boolean `OK` field can be used to indicate up/down status, while the `Errors` array will contain a list of potential error descriptions.  Granular, per-check information, including the last time a check was run, and the Kuberhealthy pod that ran that specific check is available under the `CheckDetails` object.

```json
  {
  "OK": true,
  "Errors": [],
  "CheckDetails": {
    "ComponentStatusChecker": {
      "OK": true,
      "Errors": [],
      "LastRun": "2018-06-21T17:32:16.921733843Z",
      "AuthorativePod": "kuberhealthy-7cf79bdc86-m78qr"
    },
    "DaemonSetChecker": {
      "OK": true,
      "Errors": [],
      "LastRun": "2018-06-21T17:31:33.845218901Z",
      "AuthorativePod": "kuberhealthy-7cf79bdc86-m78qr"
    },
    "PodRestartChecker namespace kube-system": {
      "OK": true,
      "Errors": [],
      "LastRun": "2018-06-21T17:31:16.45395092Z",
      "AuthorativePod": "kuberhealthy-7cf79bdc86-m78qr"
    },
    "PodStatusChecker namespace kube-system": {
      "OK": true,
      "Errors": [],
      "LastRun": "2018-06-21T17:32:16.453911089Z",
      "AuthorativePod": "kuberhealthy-7cf79bdc86-m78qr"
    }
  },
  "CurrentMaster": "kuberhealthy-7cf79bdc86-m78qr"
}
```

For more details, see the [Kuberhealthy web site](https://comcast.github.io/kuberhealthy/).

To report a bug, see the [Kuberhealthy project issues](https://github.com/Comcast/kuberhealthy/issues).
