# OpenMPI

OpenMPI is a High Performance Message Passing Library.

For more information,
[visit OpenMPI](https://www.open-mpi.org/).

## Introduction

This chart implements a solution of automatic configuration and deployment for OpenMPI, it deploys the mpi workers as statefulset, and can discover the host list automatically.


## Installing the Chart

* To install the chart with the release name `openmpi`:

```bash
$ helm install --name openmpi incubator/openmpi
```

* To install with custom values via file:


  ```
  $ helm install --name openmpi incubator/openmpi
  ```
  
  Below is an example of the custom value file openmpi.yaml.
  
  ```
  # Sample contents of openmpi.yaml
  # Default values for openmpi.
  # This is a YAML-formatted file.
  # Declare variables to be passed into your templates.

  mpiWorker:
     number: 5
     image: cheyang/openmpi:3.0.0
     imagePullPolicy: IfNotPresent
     sshPort: 22
  ```


> Notice: the dockerfile of building docker image is [openmpi Dockerfile](https://github.com/cheyang/openmpi-docker/blob/master/Dockerfile)

## Run OpenMPI

* As the sample above, there are 5 mpi workers

```
# check the statefulset
$ kubectl get sts
kubectl get sts
NAME             DESIRED   CURRENT   AGE
openmpi   5         5         20s
# wait until the last pod ready
$ kubectl get po -l chart=openmpi-0.1.0
NAME               READY     STATUS    RESTARTS   AGE
openmpi-0   1/1       Running   0          3h
openmpi-1   1/1       Running   0          3h
openmpi-2   1/1       Running   0          3h
openmpi-3   1/1       Running   0          3h
openmpi-4   1/1       Running   0          3h
```

* Run mpiexec now via 'kubectl exec' on any worker

```
# machine list is generated in '/openmpi/generated/hostfile'
$ kubectl exec -it openmpi-0 -- mpiexec --allow-run-as-root \
   --hostfile /openmpi/generated/hostfile --display-map -n 5 -npernode 1 \
   --mca orte_keep_fqdn_hostnames t \
   sh -c  'echo $(hostname):$(ifconfig eth0 | grep "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1)'
Warning: Permanently added 'openmpi-0.openmpi-svc,172.16.3.76' (ECDSA) to the list of known hosts.
Warning: Permanently added 'openmpi-1.openmpi-svc,172.16.4.38' (ECDSA) to the list of known hosts.
Warning: Permanently added 'openmpi-2.openmpi-svc,172.16.3.77' (ECDSA) to the list of known hosts.
Warning: Permanently added 'openmpi-3.openmpi-svc,172.16.3.78' (ECDSA) to the list of known hosts.
 Data for JOB [43579,1] offset 0 Total slots allocated 14

 ========================   JOB MAP   ========================

 Data for node: openmpi-4  Num slots: 1  Max slots: 0  Num procs: 1
  Process OMPI jobid: [43579,1] App: 0 Process rank: 0 Bound: N/A

 Data for node: openmpi-0.openmpi-svc  Num slots: 4  Max slots: 0  Num procs: 1
  Process OMPI jobid: [43579,1] App: 0 Process rank: 1 Bound: N/A

 Data for node: openmpi-1.openmpi-svc  Num slots: 1  Max slots: 0  Num procs: 1
  Process OMPI jobid: [43579,1] App: 0 Process rank: 2 Bound: N/A

 Data for node: openmpi-2.openmpi-svc  Num slots: 4  Max slots: 0  Num procs: 1
  Process OMPI jobid: [43579,1] App: 0 Process rank: 3 Bound: UNBOUND

 Data for node: openmpi-3.openmpi-svc  Num slots: 4  Max slots: 0  Num procs: 1
  Process OMPI jobid: [43579,1] App: 0 Process rank: 4 Bound: N/A

 =============================================================
 ....
openmpi-0:172.16.3.76
openmpi-3:172.16.3.78
openmpi-2:172.16.3.77
openmpi-1:172.16.4.38
openmpi-4:172.16.4.39
```


## Uninstalling the Chart

To uninstall/delete the `openmpi` deployment:

```bash
$ helm delete openmpi
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following tables lists the configurable parameters of the Service Tensorflow training
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mpiWorker.number`|  The mpi worker's number | `5` |
| `mpiWorker.image.repository` | image repository for the service openmpi | `cheyang/openmpi:3.0.0` |
| `mpiWorker.image.tag` | image repository for the service openmpi | `cheyang/openmpi:3.0.0` |
| `mpiWorker.image.pullPolicy` | `imagePullPolicy` for the service openmpi | `IfNotPresent` |
| `mpiWorker.sshPort` | mpiWorker's sshPort | `22` |
| `mpiWorker.podManagementPolicy` | mpiWorker's podManagementPolicy | `Parallel` |
| `mpiWorker.env` | mpiWorker's environment varaibles | `{}` |
| `persistence.pvc.storage`| the storage size to request | `5Gi` |
| `persistence.pvc.matchLabels`| the selector for pv  | `{}` |



