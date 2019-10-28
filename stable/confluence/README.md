# Confluence

Confluence是专业的企业知识管理与协同工具，可用于构建企业wiki。其强大的编辑和站点管理特征能够帮助团队成员之间共享信息、文档协作、集体讨论、信息推送。

## 介绍

此chart使用Helm包管理器，在kubernetes集群上部署单节点confluence。

## 先决条件

- Kubernetes 1.6+ 
- PV provisioner support in the underlying infrastructure
- Postgresql 9.5
- helm3 +

## 安装Chart

部署的chart名称为 `my-release`:

```bash
$ helm install my-release stable/confluence
```

该命令以默认配置在kubernetes集群上部署confluence，具体配置在`配置`部分有详细说明。

> **Tip**: 使用 `helm list`列出所有release。

## 卸载Chart

卸载部署的 `my-release` :

```bash
$ helm uninstall my-release
```

该命令删除与chart关联的所有kubernets资源对象，并删除release信息。

## 配置

下表列出了confluence chart的可配置参数及其默认值。

| Parameter                              | Description                                                  | Default                                     |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------- |
| `deployment.enabled`                   | 是否部署deployment                                           | `true`                                      |
| `replicas`                             | initContainer resource requests/limits                       | `1`                                         |
| `affinity`                             | 亲和性调度                                                   | `{}`                                        |
| `container.repository`                 | 镜像地址                                                     | `atlassian/confluence-server:6.15.9-alpine` |
| `container.imagePullPolicy`            | 镜像拉取策略                                                 | `Always`                                    |
| `container.runAsUser`                  | 容器运行用户                                                 | `0`                                         |
| `container.httpPort`                   | 容器运行端口                                                 | `8090`                                      |
| `container.imagePullSecrets`           | 拉取镜像的secret                                             | 默认不开启                                  |
| `commonResources.requests.cpu`         | 容器最小cpu使用大小                                          | `2`                                         |
| `commonResources.requests.memory`      | 容器最小内存使用大小                                         | `4Gi`                                       |
| `commonResources.limits.cpu`           | 容器最大cpu使用大小                                          | `2`                                         |
| `commonResources.limits.memory`        | 容器最大内存使用大小                                         | `4Gi`                                       |
| `probe.enabled`                        | 是否开启健康检查                                             | `true`                                      |
| `probe.type`                           | 健康检查类型，支持httpGet、tcpSocket两种方式                 | `httpGet`                                   |
| `probe.tcpSocket.port`                 | tcpSocket方式健康检查的端口号                                | `8090`                                      |
| `probe.httpGet.path`                   | httpGet方式健康检查的path                                    | `/`                                         |
| `probe.httpGet.port`                   | httpGet方式健康检查的端口号                                  | `8090`                                      |
| `probe.liveness.initialDelaySeconds`   | 探针启动前的延迟时间                                         | `90`                                        |
| `probe.liveness.timeoutSeconds`        | 探针检查超时时间                                             | `30`                                        |
| `probe.liveness.periodSeconds`         | 探针多久进行一次检查                                         | `30`                                        |
| `probe.readinesse.initialDelaySeconds` | 就绪启动前的延迟时间                                         | `90`                                        |
| `probe.readinesse.timeoutSeconds`      | 就绪检查超时时间                                             | `30`                                        |
| `probe.readinesse.periodSeconds`       | 就绪多久进行一次检查                                         | `30`                                        |
| `service.enabled`                      | 是否创建service                                              | `true`                                      |
| `service.type`                         | service对外提供方式，支持NodePort、ClusterIP、LoadBalancer。 | `NodePort`                                  |
| `extraVolumes.enabled`                 | 是否启动pvc挂载                                              | `false`                                     |
| `extraVolumes.name`                    | pvc名称                                                      | `confluence`                                |

使用参数部署：

```bash
$ helm install my-release \
  --set container.repository=atlassian/confluence-server:6.15.9-alpine,extraVolumes.enabled=true,extraVolumes.name=confluence stable/confluence
```

或者，可以在安装chart时提供指定values.yaml文件:

```bash
$ helm install my-release -f values.yaml stable/confluence
```
