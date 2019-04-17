# Upgrading Code Dx

The Code Dx deployment is using a `Replicate` deployment strategy and only one replica by default, ensuring that no more than one instance of Code Dx is operating against a database at any given time. This is particularly important during upgrades of the Code Dx image. If a database schema update occurs while more than once instance of Code Dx is running against that database, it will lead to errors, data loss, and possibly corruption of the database.

This does mean that zero-downtime updates are not currently possible with Code Dx. Research is being done to better support this.

To upgrade Code Dx to a new version, first [find the Code Dx version to upgrade to on Docker.](https://hub.docker.com/r/codedx/codedx-tomcat/tags) **Note that only Code Dx v3.6.0 and higher are kubernetes-compatible.** Then change the image used in the Code Dx deployment.

File and database data will be retained. If a license was provided via Helm when Code Dx was first installed, it must also be provided here.

## Performing the Upgrade

We recommend using a `values.yaml` file and modifying the `codedxTomcatVersion` value.

```yaml
# values.yaml
codedxTomcatVersion: "<new-codedx-image>"
```

```bash
# Direct call
helm upgrade {my-codedx} codedx/codedx --set codedxTomcatVersion=codedx/codedx-tomcat:vX.Y.Z
```

- `<new-codedx-image>`: The full name of a Code Dx image [from docker](https://hub.docker.com/r/codedx/codedx-tomcat/tags), ie `codedx/codedx-tomcat:v3.6.0`
- `{my-codedx}`: The name of the Code Dx installation, which is set when installing Code Dx via `helm install`. If installed via `helm install --name my-install ...`, the installation name would be `my-install`. If no name was specified, it will default to `codedx`.

**Be sure to include any additional values used in previous upgrades or installations.** If you passed a custom `values.yaml` file via `-f my-values.yaml`, make sure to include this file during the upgrade call. Otherwise, helm may modify Code Dx in unintended ways.

## Confirming a Successful Upgrade

Running `kubectl get pods --watch` should show the old Code Dx pod terminating. Another Code Dx pod will be created after the old pod finishes, and will begin the installation process before continuing to start up normally. Once the pod shows a status of `READY 1/1`, navigate to Code Dx and you should be able to sign in. The Code Dx version and build date on the top-right of the page should be updated accordingly.
