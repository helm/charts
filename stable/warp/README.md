Warp
=====

[Warp](https://github.com/minio/warp) is a S3 Server benchmarking tool from [MinIO](https://min.io/) team.

Introduction
------------

This chart bootstraps Warp deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Prerequisites
-------------

- Kubernetes 1.5+.

Installing the Chart
--------------------

Install this chart using:

```bash
$ helm install my-release stable/warp
```

The command deploys Warp on the Kubernetes cluster in the default configuration. The [configuration](./values.yaml) file lists the parameters that can be configured during installation. For configuring Warp, refer the [Warp documentation](https://github.com/minio/warp#usage).

### Benchmark results

After Warp chart is successfully deployed, use the `kubectl get pods` command to find out the Pod related to Warp Job. For example:

```sh
$ kubectl get pods
NAME         READY   STATUS      RESTARTS   AGE
warp-0       1/1     Running     0          11m
warp-1       1/1     Running     0          11m
warp-2       1/1     Running     0          11m
warp-3       1/1     Running     0          11m
warp-df9cs   0/1     Completed   0          11m
```

Then, use the `kubectl logs` command to get the output from Job Pod. Here you can see the benchmark results.

```sh
$ kubectl logs warp-df9cs
....
....
....
-------------------
Skipping PUT too few samples.
-------------------
Operation: GET. Concurrency: 4. Hosts: 4.
* Average: 448.97 MiB/s, 89.79 obj/s (4m59.883s, starting 14:01:09 UTC)

Throughput by host:
 * http://minio-1.minio.default.svc.cluster.local:9000: Avg: 112.26 MiB/s, 22.45 obj/s (4m59.834s, starting 14:01:09 UTC)
 * http://minio-2.minio.default.svc.cluster.local:9000: Avg: 112.27 MiB/s, 22.45 obj/s (4m59.797s, starting 14:01:09 UTC)
 * http://minio-3.minio.default.svc.cluster.local:9000: Avg: 112.27 MiB/s, 22.45 obj/s (4m59.938s, starting 14:01:09 UTC)
 * http://minio-0.minio.default.svc.cluster.local:9000: Avg: 112.27 MiB/s, 22.45 obj/s (4m59.934s, starting 14:01:09 UTC)

Aggregated Throughput, split into 299 x 1s time segments:
 * Fastest: 580.4MiB/s, 116.09 obj/s (1s, starting 14:01:11 UTC)
 * 50% Median: 471.9MiB/s, 94.38 obj/s (1s, starting 14:04:25 UTC)
 * Slowest: 189.4MiB/s, 37.87 obj/s (1s, starting 14:02:23 UTC)
```
