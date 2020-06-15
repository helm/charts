# Outline

This example describes how to create Web frontend server, an auto-provisioned persistent volume on GCE or Azure, and an NFS-backed persistent claim.

Demonstrated Kubernetes Concepts:

* [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) to define persistent disks (disk lifecycle not tied to the Pods).
* [Services](https://kubernetes.io/docs/concepts/services-networking/service/) to enable Pods to locate one another.

![alt text][nfs pv example]

As illustrated above, two persistent volumes are used in this example:

- Web frontend Pod uses a persistent volume based on NFS server, and
- NFS server uses an auto provisioned [persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) from GCE PD or AWS EBS or Azure Disk.

Note, this example uses an NFS container that doesn't support NFSv4.

[nfs pv example]: nfs-pv.png


## Quickstart

```console
# On GCE (create GCE PD PVC):
$ kubectl create -f examples/staging/volumes/nfs/provisioner/nfs-server-gce-pv.yaml
# On Azure (create Azure Disk PVC):
$ kubectl create -f examples/staging/volumes/nfs/provisioner/nfs-server-azure-pv.yaml
# Common steps after creating either GCE PD or Azure Disk PVC:
$ kubectl create -f examples/staging/volumes/nfs/nfs-server-rc.yaml
$ kubectl create -f examples/staging/volumes/nfs/nfs-server-service.yaml
# get the cluster IP of the server using the following command
$ kubectl describe services nfs-server
# use the NFS server IP to update nfs-pv.yaml and execute the following
$ kubectl create -f examples/staging/volumes/nfs/nfs-pv.yaml
$ kubectl create -f examples/staging/volumes/nfs/nfs-pvc.yaml
# run a fake backend
$ kubectl create -f examples/staging/volumes/nfs/nfs-busybox-rc.yaml
# get pod name from this command
$ kubectl get pod -l name=nfs-busybox
# use the pod name to check the test file
$ kubectl exec nfs-busybox-jdhf3 -- cat /mnt/index.html
```

## Example of NFS-based persistent volume

See [NFS Service and Replication Controller](templates/nfs-web-rc.yaml) for a quick example of how to use an NFS volume claim in a replication controller. It relies on the [NFS persistent volume](templates/nfs-pv.yaml) and [NFS persistent volume claim](templates/nfs-pvc.yaml) in this example as well.

## Complete setup

The example below shows how to export a NFS share from a single pod replication controller and import it into two replication controllers.

### NFS server part

Define [the NFS Service and Replication Controller](templates/nfs-server-deployment.yaml) and [NFS service](templates/nfs-server-service.yaml):

The NFS server exports an auto-provisioned persistent volume backed by GCE PD or Azure Disk. If you are on GCE, create a GCE PD-based PVC:

```bash
$ kubectl create -f examples/staging/volumes/nfs/provisioner/nfs-server-gce-pv.yaml
```

If you are on Azure, create an Azure Premium Disk-based PVC:

```bash
$ kubectl create -f examples/staging/volumes/nfs/provisioner/nfs-server-azure-pv.yaml
```

Then using the created PVC, create an NFS server and service:

```bash
$ kubectl create -f examples/staging/volumes/nfs/nfs-server-rc.yaml
$ kubectl create -f examples/staging/volumes/nfs/nfs-server-service.yaml
```

The directory contains dummy `index.html`. Wait until the pod is running by checking `kubectl get pods -l role=nfs-server`.

### Create the NFS based persistent volume claim

The [NFS busybox controller](templates/nfs-busybox-rc.yaml) uses a simple script to generate data written to the NFS server we just started. 

Create the [persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and the persistent volume claim for your NFS server. The persistent volume and claim gives us an indirection that allow multiple pods to refer to the NFS server using a symbolic name rather than the hardcoded server address.

```bash
$ kubectl create -f examples/staging/volumes/nfs/nfs-pv.yaml
$ kubectl create -f examples/staging/volumes/nfs/nfs-pvc.yaml
```

## Set up the fake backend

The [NFS busybox controller](templates/nfs-busybox-rc.yaml) updates `index.html` on the NFS server every 10 seconds. Let's start that now:

```bash
$ kubectl create -f examples/staging/volumes/nfs/nfs-busybox-rc.yaml
```

Conveniently, it's also a `busybox` pod, so we can get an early check that our mounts are working now. Find a busybox pod and exec:

```bash
$ kubectl get pod -l name=nfs-busybox
NAME                READY     STATUS    RESTARTS   AGE
nfs-busybox-jdhf3   1/1       Running   0          25m
nfs-busybox-w3s4t   1/1       Running   0          25m
$ kubectl exec nfs-busybox-jdhf3 -- cat /mnt/index.html
Thu Oct 22 19:20:18 UTC 2015
nfs-busybox-w3s4t
```

You should see output similar to the above if everything is working well. If it's not, make sure the `describe services` command above had endpoints listed (indicating the service was associated with a running pod).

### Set up the web server

The [web server controller](templates/nfs-web-rc.yaml) is an another simple replication controller demonstrates reading from the NFS share exported above as a NFS volume and runs a simple web server on it.

Define the pod:

```bash
$ kubectl create -f examples/staging/volumes/nfs/nfs-web-rc.yaml
```

This creates two pods, each of which serve the `index.html` from above. We can then use a simple service to front it:

```bash
$ kubectl create -f examples/staging/volumes/nfs/nfs-web-service.yaml
```

We can then use the busybox container we launched before to check that `nginx` is serving the data appropriately:

```bash
$ kubectl get pod -l name=nfs-busybox
NAME                READY     STATUS    RESTARTS   AGE
nfs-busybox-jdhf3   1/1       Running   0          1h
nfs-busybox-w3s4t   1/1       Running   0          1h
$ kubectl get services nfs-web
NAME      LABELS    SELECTOR            IP(S)        PORT(S)
nfs-web   <none>    role=web-frontend   10.0.68.37   80/TCP
$ kubectl exec nfs-busybox-jdhf3 -- wget -qO- http://10.0.68.37
Thu Oct 22 19:28:55 UTC 2015
nfs-busybox-w3s4t
```


