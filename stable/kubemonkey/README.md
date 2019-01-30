# Kube-Monkey Helm Chart

[Kube-Monkey](https://github.com/asobti/kube-monkey) periodically kills pods in your Kubernetes cluster,that are opt-in based on their own rules.

## Official Helm

TBA to official helm charts,There is no official helm chart yet for kube-monkey.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/kubemonkey
```
**Note :** by default kube-monkey installed to the default namespace, you can assign diffrent namespace (which is the suggested approach ) by passing --namespace=your namespace name.

The command deploys kube-monkey on the Kubernetes cluster in the default configuration. The [configurations](#Configurations) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Customising Configurations

By default `Kube-Monkey` runs in dry-run mode so it doesn't actually kill anything.
If you're confident you want to use it in real run `helm` with:

```console
$ helm install --name my-release stable/kubemonkey --set config.dryRun=false
```

By default `Kube-Monkey` runs in without any white listed namespace assigned so it doesn't actually kill anything.
If you're confident you want to enable it in real, run `helm` with:

```console
$ helm install --name my-release stable/kubemonkey \
               --set config.dryRun=false \
               --set config.whitelistedNamespaces="namespace1\"\,\"namespace2\"\,\"namespace3"
```

**Note: replace namespace with your real namespaces**

If you want to see how kube-monkey kills pods immediatley in debub mode.

```console
$ helm install --name my-release stable/kubemonkey \
               --set config.dryRun=false \
               --set config.whitelistedNamespaces="namespace1\"\,\"namespace2\"\,\"namespace3" \
               --set config.debug.enabled=true \
               --set config.debug.schedule_immediate_kill=true
```
If you want change time kube-monkey wakesup and start and end killing pods.

```console
$ helm install --name my-release stable/kubemonkey \
               --set config.dryRun=false \
               --set config.whitelistedNamespaces="namespace1\"\,\"namespace2\"\,\"namespace3" \
               --set config.runHour=10 \
               --set config.startHour=11 \
               --set config.endHour=17 
```
If you want validate intended values passed in to configmap .

```console
$ helm get manifest my-release
```
## Configurations

| Parameter                 | Description                                         | Default                          |
|---------------------------|-----------------------------------------------------|----------------------------------|
| `image.repository`        | docker image repo                                   | ayushsobti/kube-monkey           |
| `image.tag`               | docker image tag                                    | v0.3.0                           |
| `replicaCount`            | number of replicas to run                           | 1                                |
| `rbac.enabled`            | rbac enabled or not                                 | true                             |
| `image.tag.IfNotPresent`  | image pull logic                                    | IfNotPresent                     |
| `config.dryRun`           | will not kill pods, only logs behaviour             | false                            |
| `config.runHour`          | schedule start time in 24hr format                  | 8                                |
| `config.startHour`        | pod killing start time  in 24hr format              | 10                               |
| `config.endHour`          | pod killing stop time  in 24hr format               | 16                               |
| `config.whitelistedNamespaces`| pods in this namespace that opt-in will be killed|                                 |
| `config.endHour.blacklistedNamespaces`| pods in this namespace will not be killed| kube-system                     |
| `config.timeZone`         | time zone in DZ format                              | America/New_York                 |
| `config.debug.enabled`    | debug mode,need to be enabled to see debuging behaviour| false                         |
| `config.debug.schedule_immediate_kill` | immediate pod kill matching other rules apart from time| false            |
| `args.logLevel`           | go log level                                        | 5                                |
| `args.logDir`             | log directory                                       | /var/log/kube-monkey             |

after all you can simply edit a copy of  values.yaml with your prefered configs and run as below

```console
$ helm install --name my-release stable/kubemonkey -f values.yaml
```
example of a modified values.yaml (only important parts are displayed)

```yaml
...
replicaCount: 1
rbac:
  enabled: true
image:
  repository: ayushsobti/kube-monkey
  tag: v0.3.0
  pullPolicy: IfNotPresent
config:
  dryRun: false
  runHour: 8
  startHour: 10
  endHour: 16
  blacklistedNamespaces: kube-system
  whitelistedNamespaces: namespace1,namespace2
  timeZone: America/New_York
  debug:
   enabled: true # if you want to enable debugging and see how pods killed immediately set this to true
   schedule_immediate_kill: true
args:
  logLevel: 5
  logDir: /var/log/kube-monkey
...
```
