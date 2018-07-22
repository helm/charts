# Helm Chart for Spark History Server

[Spark History Server](https://spark.apache.org/docs/latest/monitoring.html#viewing-after-the-fact) provides a web UI for completed and running Spark applications.

#### Prerequisites

1. <a name="controller"></a>Ingress Controller

   The Spark history server UI is exposed using a Kubernetes ingress resource, which requires an ingress controller to be installed in the cluster. This chart by default supports [Traefik](https://docs.traefik.io/user-guide/kubernetes/). The installation of Traefik can be done with the following YAML:

   ```yaml
   apiVersion: extensions/v1beta1
   kind: Deployment
   apiVersion: extensions/v1beta1
   metadata:
     name: traefik-ingress-controller
     namespace: kube-system
     labels:
       k8s-app: traefik-ingress-lb
   spec:
     replicas: 1
     selector:
       matchLabels:
         k8s-app: traefik-ingress-lb
     template:
       metadata:
         labels:
           k8s-app: traefik-ingress-lb
           name: traefik-ingress-lb
       spec:
         serviceAccountName: traefik-ingress-controller
         terminationGracePeriodSeconds: 60
         containers:
         - image: traefik
           name: traefik-ingress-lb
           args:
           - --web
           - --kubernetes
           ports:
           - name: http
             containerPort: 80
             hostPort: 9900
           - name: admin
             containerPort: 8080
             hostPort: 9901
         affinity:
           podAntiAffinity:
             requiredDuringSchedulingIgnoredDuringExecution:
             - labelSelector:
                 matchExpressions:
                 - key: k8s-app
                   operator: In
                   values:
                   - traefik-ingress-lb
               topologyKey: "kubernetes.io/hostname"
         nodeSelector:
           kubernetes.dcos.io/node-type: public
         tolerations:
         - key: "node-type.kubernetes.dcos.io/public"
           operator: "Exists"
           effect: "NoSchedule"
   ---
   kind: ClusterRole
   apiVersion: rbac.authorization.k8s.io/v1beta1
   metadata:
     name: traefik-ingress-controller
   rules:
     - apiGroups:
         - ""
       resources:
         - services
         - endpoints
         - secrets
       verbs:
         - get
         - list
         - watch
     - apiGroups:
         - extensions
       resources:
         - ingresses
       verbs:
         - get
         - list
         - watch
   ---
   kind: ClusterRoleBinding
   apiVersion: rbac.authorization.k8s.io/v1beta1
   metadata:
     name: traefik-ingress-controller
   roleRef:
     apiGroup: rbac.authorization.k8s.io
     kind: ClusterRole
     name: traefik-ingress-controller
   subjects:
   - kind: ServiceAccount
     name: traefik-ingress-controller
     namespace: kube-system
   ---
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: traefik-ingress-controller
     namespace: kube-system
   ```

   which exposes the Traefik admin UI at port `9901` and user-deployed service UIs at port `9900`.

2. HDFS ConfigMaps

   This chart supports specifying an HDFS location as the log directory. In order for the Spark history server to communicate with HDFS, two HDFS files need to be mounted as configMaps in the Kubernetes cluster. Locate your `hdfs-site.xml` and `core-site.xml` and then run the following two commands to create configMaps:

   ```bash
   $ kubectl create configmap hdfs-site --from-file=hdfs-site.xml && kubectl create configmap core-site --from-file=core-site.xml
   ```

   Then the two files would be mounted in the Docker image when the chart is installed.

#### Installing the Chart

To install the chart:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/spark-history-server
```

#### Configurations

The following tables lists the configurable parameters of the Spark History Sever chart and their default values.

| Parameter                            | Description                                                       |Default                           |
| ------------------------------------ |----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| hdfs.logDirectory                |The URL to the directory containing application event logs to load. Currently only supports an HDFS location.|hdfs://hdfs/history/|
| hdfs.hdfsSiteConfigMap |The name of the configMap for hdfs-site.xml|hdfs-site|
| hdfs.coreSiteConfigMap |The name of the configMap for core-site.xml|Core-site|
| image.repository |The Docker image used to start the history server daemon|lightbend/spark-history-server|
| image.tag |The tag of the image|2.3.1|
| ingress.baseURL |The service path where the history server UI can be accessed|/spark-history-server|
| ingress.controller |The ingress controller to use|traefik|
| ingress.label |The label for the ingress controller|traefik-ingress-lb|

#### Viewing the UI

The Spark history server UI is exposed using an ingress. If the default Traefik ingress controller is installed using the instructions in the [Prerequisites](#controller) section, then the Spark history server UI can be accessed by first looking up the IP of the node where the Traefik pod is running, and then going to the pre-specified port and service path (e.g. http://kube-node-public-0-kubelet.kubernetes.mesos:9900/spark-history-server).

