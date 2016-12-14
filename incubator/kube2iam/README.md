# kube2iam Helm Chart

* Installs [kube2iam](https://github.com/jtblin/kube2iam), useful when pods need AWS IAM roles

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/kube2iam
```

## Configuration

| Parameter                  | Description                                       | Default                  |
|----------------------------|---------------------------------------------------|--------------------------|
| `image`                    | kube2iam container image                          | jtblin/kube2iam          |
| `version`                  | kube2iam version                                  | 0.3.0                    |
| `baseRoleArn`              | Base ARN to apply to all roles                    | arn:aws:iam::123456789012|
| `exposedPort`              | Port where kube2iam will be listening             | 8181                     |
| `cpuRequests`              | Requested CPU                                     | 10m                      |
| `cpuLimits`                | CPU limit                                         | 100m                     |
| `memoryRequests`           | Requested memory                                  | 128Mi                    |
| `memoryLimits`             | Memory limit                                      | 256Mi                    |