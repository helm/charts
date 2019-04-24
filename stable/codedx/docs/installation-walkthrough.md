
# Installation Walkthrough

This document will guide you through the deployment of a basic Code Dx installation, including recommended practices and caveats.

# Preparation

The Code Dx Helm chart requires that Helm be installed to your cluster. Helm is a Kubernetes package manager that makes it easy to define customizable Kubernetes resources and install them in a consistent way.

Installation instructions can be found [in their official documentation](https://helm.sh/docs/using_helm/). Some extra setup is required if Pod Security Policies are enforced on your cluster, so that the Helm Tiller pod (which manages Helm installations) can create resources. Further details and instructions can be found in the section [Installing Helm](#Installing-Helm) below.

## Installing Helm

Go to the [official installation guide](https://helm.sh/docs/using_helm/) to install Helm to your cluster. Helm only needs to be installed to your cluster once, but the Helm client will need to be installed on any machine that wants to use it for managing installations.

If you have Pod Security Policies enabled and enforced in your cluster, Helm will fail to deploy any charts. The file [helm-tiller-resources.yaml](../sample-values/helm-tiller-resources.yaml) with this repository can be used to define a Pod Security Policy, Service Account, and Role Binding for Helm. Download the file, modify as necessary for your configuration, and run:

```bash
$ kubectl create -f helm-tiller-resources.yaml
$ helm init --upgrade --service-account helm-tiller
```

This will create the described resources, and update Helm to use the new Service Account when running.

## Registering the Code Dx Repository

Once Helm is installed, the Code Dx Charts repository must be registered for Helm to know about the chart. Run this command to register the Code Dx repository:

```bash
$ helm repo add codedx https://codedx.github.io/codedx-kubernetes
```

Test that it installed correctly by running:

```bash
$ helm install codedx/codedx --dry-run
NAME:   mouthy-boxer
```

This command with `--dry-run` will not install Code Dx, but will try to evaluate the kubernetes resources with the `codedx/codedx` chart. If it runs successfully, it will output a randomly-generated name for the Code Dx installation that would have been deployed. Each deployment managed by Helm has a name that is referred to for later operations like upgrading and deleting.

## Making a Configuration File

The Code Dx Helm chart has many configuration options. When installing or updating Code Dx with Helm, customized options must be specified each time you update. If Code Dx is installed with a license file, and its configuration is later updated without that license file, Helm will remove that license from Kubernetes.

To simplify configuration, and to prevent mistakes, we will start by creating a `values.yaml` file containing our options. This is not required but highly recommended. We will give this file to Helm when performing any operations.

Download a copy of [values-base-install.yaml](../sample-values/values-base-install.yaml) locally for an example configuration file. If installing Code Dx with a license readily available, check the [Code Dx Licensing](codedx-licensing.md) guide for different methods on providing a license.

Code Dx can be installed with the basic options in `values-base-install.yaml`, and modified later as necessary.

The complete set of configuration options are documented and available in the default [values.yaml](../values.yaml) file provided with this chart.

# Installing Code Dx

> If you've previously installed a different Code Dx version in your cluster and uninstalled it using `helm delete`: You should first manually delete the Persistent Volume Claims left over by the old MariaDB installation, or install Code Dx under a different name/namespace. These left over PVCs _can_ cause conflicts, though this usually isn't an issue.

With your `values.yaml` file in your current directory, run the command:

```bash
$ helm install codedx/codedx --name codedx -f values.yaml
```

> Note: The file does not specifically need to be named `values.yaml`, so long as the correct file name is passed to the `-f` parameter.

> Note: You can install Code Dx to a specific namespace with the `--namespace "..."` flag.

> Note: `--name codedx` is not required, but makes it simpler to refer to this specific installation instance later on. If omitted, a random name will be selected and output to your console.

Running this command will create various resources, output the list of generated resources to the console, and also provide instructions for Code Dx based on your configuration. If installation fails due to a configuration issue, you may need to run `helm del --purge "name"` to remove the previous, failed installation before trying again.

## Retrieve Auto-Generated Credentials

Before continuing, obtain the password for the default Code Dx admin account using the command written to your console. This should be something like:

```bash
$ echo username: admin
$ echo password: $(kubectl get secret --namespace default codedx-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
```

Copy this password somewhere temporarily. This is required for accessing Code Dx the first time, and should be changed immediately after signing in.

## Wait for Code Dx Startup

Monitor the Code Dx installation with `kubectl get pods --watch` and wait for the status of the Code Dx pod to reach `1/1 READY`. When complete, you can access the web portal by either ingress or load balancer IP depending on your configuration. In both cases, Code Dx will be available at the `/codedx` endpoint.

## Change the Admin Password

Navigate to Code Dx and sign in with the user `admin` and the password that was retrieved earlier. Go to the Admin page and change the password.

**This is important.** Since the admin password is randomly generated by helm and stored in a secret, the password will be re-generated to a new random value when changing the configuration. Therefore, retrieving the password from that secret is only useful after initially installing.

# Updating Code Dx

This section applies both for modifying your Code Dx configuration, and for upgrading to a new Code Dx version. The Code Dx version is specified by docker image name in the property `codedxTomcatImage`. The available Docker images can be found in [Docker Hub](https://hub.docker.com/r/codedx/codedx-tomcat/tags).

Modify your YAML file as necessary, and run `helm upgrade` to apply your changes:

```bash
$ helm upgrade codedx codedx/codedx -f values.yaml
```

> Note: The standalone "codedx" part of the command will be the name of your existing installation.

> Note: The namespace does not need to be specified again when using `helm upgrade`.

> Note: If a new Code Dx version is released and you have not manually assigned a Code Dx version, this will automatically update your installation to the new version. We recommend setting `codedxTomcatImage` in your `values.yaml` to prevent accidental version upgrades.

Certain configuration changes will not automatically restart Code Dx. In this case, restart Code Dx manually with `kubectl delete`.

See the other available documentation within this folder, [sample YAML files](../sample-values), and the default [values.yaml](../values.yaml) file for more configuration options.