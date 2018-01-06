# HELM Chart for Microsoft SQL Server 2017 on Linux

## Prerequisites
 * This chart requires Docker Engine 1.8+ in any of their supported platforms.
 * At least 2GB of RAM (3.25 GB prior to 2017-CU2). Make sure to assign enough memory to the Docker VM if you're running on Docker for Mac or Windows.
 * Requires the following environment flags
   - You must change the ACCEPT_EULA in the values.yaml file to `Y` or include `--set ACCEPT_EULA.value=Y` in the command line of `helm install`
   - Update the template/secret.yaml with your Base64 SA Password
   - MSSQL_PID=<your_product_id | edition_name> (default: Express)
   - A strong system administrator (SA) password: At least 8 characters including uppercase, lowercase letters, base-10 digits and/or non-alphanumeric symbols.

## Chart Components
 * Creates a SQL Server 2017 deployment (default edition: Express)
 * Creates a Kubernetes Service on specified port (default: 1433)
 * Creates a Secert to hold SA_PASSWORD

## Installing the Chart

### Creating Secrets for SA Password
It is important to change the BASE64 text in the templates/secret.yaml file to your own password.  By default, the password is `MySaPassword123`.  The instructions below are how to change the password via terminal window.
1.  Open a terminal session/window
2.  Type in the following
```console
$ echo -n "<MyNewStrongSaPassword>"| base64
$ <base 64 output>
```
3.  Copy the Base64 output in step 2 into the templates/secret.yaml in the `password` field
> Note - The `echo -n` in important to ensure no new lines are added at the end of the password

You can install the chart with the release name `mymssql` as below.
```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name mymssql incubator/mssql --set ACCEPT_EULA.value=Y
```
> Note - If you do not specify a name, helm will select a name for you.

### Installed Components
You can use `kubectl get` to view all of the installed components.

```console{%raw}
$ kubectl get all -l app=mssql
NAME                           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/mymssql-mssql          1         1         1            1           9m

NAME                           DESIRED   CURRENT   READY     AGE
rs/mymssql-mssql-8688756468   1         1         1         9m

NAME                           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/mymssql-mssql          1         1         1            1           9m

NAME                           DESIRED   CURRENT   READY     AGE
rs/mymssql-mssql-8688756468   1         1         1         9m

NAME                                 READY     STATUS    RESTARTS   AGE
po/mymssql-mssql-8688756468-x758g   1/1       Running   0          9m

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
svc/mymssql-mssql   ClusterIP   10.104.152.61   <none>        1433/TCP   9m

```

## Connecting to SQL Server Instance
1.  Run the following command
```console
$ kubectl run dbatoolbox --image=microsoft/mssql-tools -ti --restart=Never --rm=true -- /bin/bash
$ sqlcmd -S {{ template "mssql.fullname" . }}.{{ .Release.Namespace }} -U sa
Password: <Enter SA Password>
```

## Values
The configuration parameters in this section control the resources requested and utilized by the ZooKeeper ensemble.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| ACCEPT_EULA | EULA that needs to be accepted.  It will need to be changed via commandline or values.yaml. | N |
| edition | The edition of SQL Server to install | Express |
| image | |  |
| repository | The docker hub repo for SQL Server | microsoft/mssql-server-linux |
| tag | The tag for the image | latest |
| pullPolicy | The pull policy for the deployment | IfNotPresent |
| service | | |
| name | Service Name | mssqlsrvr |
| type | Service Type | ClusterIP |
| externalPort | External Port | 1433 |
| internalPort | Internal Port | 1433 |
| livenessprobe | | |
| initialDelaySeconds | Tells the kubelet that it should wait XX second(s) before performing the first probe | 15 |
| periodSeconds | Field specifies that the kubelet should perform a liveness probe every XX seconds(s) | 20 |
| readinessprobe | | |
| initialDelaySeconds | Tells the kubelet that it should wait XX second(s) before performing the first probe | 5 |
| periodSeconds | Field specifies that the kubelet should perform a liveness probe every XX second(s) | 10 | 

## Resources
Typically don't recommend specifying default resources and to leave this as a conscious
choice for the user. This also increases chances charts run on environments with little
resources, such as Minikube. If you do want to specify resources, uncomment the following
lines, adjust them as necessary, and remove the curly braces after 'resources:'.

The defaults are set for local development purposes.
```yaml
resources: #{}
   limits:
    cpu: 1
    memory: 2Gi
   requests:
    cpu: 0.5
    memory: 2Gi
```
## SQL Server for Linux Editions
 * Developer : This will run the container using the Developer Edition (this is the default if no MSSQL_PID environment variable is supplied)
 * Express : This will run the container using the Express Edition
 * Standard : This will run the container using the Standard Edition
 * Enterprise : This will run the container using the Enterprise Edition
 * EnterpriseCore : This will run the container using the Enterprise Edition Core
 * <valid product id> : This will run the container with the edition that is associated with the PID

## Creating Secrets for SA Password
It is important to change the BASE64 text in the templates/secret.yaml file to your own password.  By default, the password is `MySaPassword123`.  The instructions below are how to change the password via terminal window.
1.  Open a terminal session/window
2.  Type in the following
```console
$ echo -n "<MyNewStrongSaPassword>"| base64
$ <base 64 output>
```
3.  Copy the Base64 output in step 2 into the templates/secret.yaml in the `password` field
> Note - The `echo -n` in important to ensure no new lines are added at the end of the password