# nfs-pv-provider: a Kubernetes Helm Charts incubator project

This chart creates a container and exports a PersistentVolume via NFS to other
pods as a K8S Service.  Deployed on `k8s.gcr.io/volume-nfs` and derived from
`kubernetes/examples/staging`:
https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs

### Instructions Guide

To exercise the nfs-pv-provider, first get the `nfs-pv-provider` Helm chart
installed:

```
# .env: 
NFS_NAMESPACE=nfs
NFS_NAME=nfs

$ git clone git@github.com:kubernetes/charts -b nfs-pv charts
$ cd charts/incubator
$ helm install --namespace $NFS_NAMESPACE --name $NFS_NAME nfs-pv-provider
$ kubectl --namespace $NFS_NAMESPACE get svc -w
```

A single ClusterIP should become bound to the new `Service` that was created
almost immediately, or immediately.   That is your NFS server.  You should save
that address, or otherwise make a note of it:

```
$ kubectl -n $NFS_NAMESPACE get svc -o jsonpath="{.items[*].spec.clusterIP}"; echo
```

Then, for example, provision the PV and PVC from [kingdonb/nfs-data] in order
to make a sub-volume under `/exports` available to pods.  You can specify a
subpath or leave default `/` setting to expose `/exports` directly, but setting
clusterIP in `values.yaml` as `nfs.path` is mandatory to inform the client PV
you will create from the [templates/nfs-pv.yaml] in `kingdonb/nfs-data`.

```
git clone git@github.com:kingdonb/nfs-data
cd nfs-data
$EDITOR values.yaml
helm install --namespace nfs .
```

You must edit the values.yaml and write a ClusterIP within as described above.

(This is WIP!  Sorry, I know this is unorthodox)

### Limitations of this configuration

Due to limitations of the Kubernetes spec, it is not possible to use service
discovery when binding a PV.  It seems one needs a publically resolvable DNS
name for the NFS server, or an IP address, or if you're on Google COS I heard
it may just work to say `my-nfs-pv-provider.svc.namespace.cluster.default`.

If there's a way to solve this in Kubernetes with labels, I don't know it.

### PV within a PV: What exactly is this for?

A simple K8S PV provider built almost entirely from K8S primitive resources.

If you are used to creating PVCs that automatically generate PVs, note that you
must create both PV and PVC as the consumer of the NFS PV Provisioner service.

The PV that you create here is a ReadWriteMany clusterIP/path with capacity
settings maybe for quota purposes.  You may divide a single PV storage into
multiple PVs and connect multiple pod volumes to each of them easily.

As the PV has a ReadWriteMany semantics, you need not repeat this for each pod.
As you scale the number of pods in client deployment(s), they may any or all
select NFS volumes through any label/by name, so you can map arbitrary numbers
of containers' volumes to any number of NFS volumes in any combination.

This could be useful if in your organization's cloud account, too many storage
resources are provisioned at too low utilization rates.  This may be meant as a
tool to fight a proliferation of overprovisioned storage disk resources.

You may not be able to get all guarantees available in the set of other similar
storage solutions that may be baked into such as EFS or Azure File, but it is a
foundation for ReadWriteMany that does not require anything outside of what is
already provided by Kubernetes conformance.  (Fight vendor lock-in!)

### Consuming the filesystem(s) of the NFS PV Provisioner

Finally, mix in one or more of the example clients from [kingdonb/nfs-data]

```
kubectl -n nfs create -f example-sh-client/nfs-busybox-rc.yaml
# and/or
kubectl -n nfs create -f example-web-client/nfs-web-rc.yaml
kubectl -n nfs create -f example-web-client/nfs-web-service.yaml
```

One or more pods can connect to a ReadWriteMany PV, so only one PV and PVC
called `nfs` is created, and can serve client pods for any number of pods like
the examples in this repo!  You can also create additional PVs against the
single NFS service with a different path, using this approach to grab different
slices of /export.

Would be a nice addition to the spec to require cluster DNS is available within
service definitions, I think maybe it could be added in a future version of K8S
conformance suite requirements.  Maybe there is some technical reason relating
to TTL or otherwise why it couldn't work reliably.

I heard a rumor, that DNS in PV spec may already work if using Google's COS.

[kingdonb/nfs-data]: https://github.com/kingdonb/nfs-data
[templates/nfs-pv.yaml]: https://github.com/kingdonb/nfs-data/blob/9e7dc26a643ab8363064b84093e0dd4ef3a48523/templates/nfs-pv.yaml
