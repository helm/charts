# Identity Service

Identity Service is used to provide single-sign-on and protect Web APIs in an ASP.NET Core application. An intuitive web UI dashboard is used to carry out configuration tasks for identity and authorization.

## Features

* Single-Sign-On (SSO) using OpenID connect
* Protect Web APIs using the Client Credentials Flow
* Manage users, claims and roles for ASP.NET Core Identity

 For detailed instructions on how to use Identity Service, refer to the  [Identity Service Documentation](https://rcl-identityserver.github.io/documentation/)

## Microsoft Azure Container Service (AKS) and ASP.NET Core

Identity service is designed to be hosted in a Microsoft Azure Container Service (AKS) Kubernetes **Linux** cluster. It is geared towards developers who use ASP.NET Core to create web applications. Identity Service can be used as a gateway service to secure Web APIs in a micro services architecture. 

## Prerequisites

* Azure Container Service (AKS) Kubernetes Linux cluster
* Azure SQL Database
* SendGrid Email service

## Installing the Chart

### Azure AKS Cluster

Create an AKS Linux cluster in the Azure portal or add Identity Service to an existing AKS Linux cluster. For detailed instructions on setting up an AKS cluster refer to the  [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal)

In the cluster, install the following if they are not already installed :

* A Kubernetes supported ingress controller (eg: [nginx](https://github.com/kubernetes/charts/tree/master/stable/nginx-ingress) , [GCE](https://github.com/kubernetes/ingress-gce/blob/master/README.md))
* TLS termination (eg. [cert-manager](https://github.com/kubernetes/charts/tree/master/stable/cert-manager) or installed TLS Certificate)

For detailed instructions on these installations refer to the  [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/ingress)

### NGINX Ingress Controller Proxy Buffer Size

This applies if you are using the NGINX ingress controller. The NGINX ingress controller Proxy Buffer Size is not large enough for the headers returned by Identity Service. You will need to increase the buffer size. Create a ConfigMap file called nginx-configuration.yaml and add this code. Replace the placeholder text with your nginx pod name.

```yaml
kind: ConfigMap  
apiVersion: v1  
metadata:  
  name: your-nginx-pod-name
  namespace: kube-system
data:  
  proxy-buffer-size: "16k"
```

This is an example of an actual ConfigMap.

```yaml
kind: ConfigMap  
apiVersion: v1  
metadata:  
  name: foppish-cow-nginx-ingress-controller-54757d5f56-jxrrl 
  namespace: kube-system
data:  
  proxy-buffer-size: "16k"
```

In your cluster, run the following command:

```bash
kubectl apply -f nginx-configuration.yaml 
```

The nginx ingress controller will be updated and restarted with the new configuration value.

### Azure SQL Database

Identity Service stores its data in a SQL Database. Install an Azure SQL Database in your azure account or use an existing database and copy the following for use later on : 

* SQL Server name
* SQL Server database name
* SQL Server login username
* SQL Server login password

For detailed instructions, refer to the  [Azure SQL Server Documentation](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-get-started-portal)

### SendGrid Email Service

Identity Service requires verification of emails when a user first registers. We use the SendGrid email service for this. Install SendGrid in your Azure account or use an existing installation and copy the **SendGrid API Key** for use later on. For detailed instructions, refer to the  [Azure Send Grid Documentation](https://docs.microsoft.com/en-us/azure/sendgrid-dotnet-how-to-send-email)

### Helm repository

### Install the chart

Install the chart with the following command , the parameters shown are all mandatory (replace the placeholder text with your own data) :

```bash
helm install incubator/identityservice \
  --set dbServerName=your-db-server-name \
  --set dbName=your-db-name \
  --set dbUserName=your-db-server-username \
  --set dbPassword=your-db-server-password \
  --set sendgridKey=your-sendgrid-api-key \
  --set adminEmail=your-admin-email-address \
  --set host=your-dns-name-for-public-ip-of-cluster-or-registered-domain-name*
```

The following is an example of an installation command :

```bash
helm install incubator/identityservice \
  --set dbServerName=contosodbsvr.database.windows.net\
  --set dbName=contosodb \
  --set dbUserName=montanadmin \
  --set dbPassword=#gtrewsbg15 \
  --set sendgridKey=RF.F9HI8YgPRvpGxwp8__rWPB.n6O4WDjY8krPwMqPRWpTp0HdWKdo74eoCePoeFrH2fc \
  --set adminEmail=contosoadmin@gmail.com \
  --set host=contoso.eastus.cloudapp.azure.com
```

### Access the Identity Service UI dashboard

Once Identity Service is running in your cluster, you can access the UI dashboard at the following address :

https://your-dns-name/identitysvc

You will need to do some configuration of the UI before you can use the application. Just follow the steps on the setup page when you first open the UI dashboard.

### Helm chart configuration parameters

| Parameter           | Description                                                                    |Default
| ------------------- |:------------------------------------------------------------------------------:|:--------
| dbServerName        | The name of your Azure SQL Database Server                                     | nil
| dbName              | The name of your Azure SQL Database                                            | nil
| dbUsername          | The username for your Azure SQL Database Server                                | nil
| dbPassword          | The password for your Azure SQL Database Server                                | nil
| sendgridKey         | Your SendGrid API Key                                                          | nil
| adminEmail          | The email address to use for your admin account                                | nil
| host                | The DNS name for the public IP of the cluster, or your registered domain name  | nil


* For a custom host, you can register your custom domain with a domain service provider that points to the static IP (A record) or DNS (CNAME Record) of your AKS cluster.  







