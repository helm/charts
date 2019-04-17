# Code Dx Configuration

## General

Configuration of Code Dx itself is done through a primary ConfigMap and Secrets. A ConfigMap is generated when installing Code Dx with a `codedx.props` entry that contains common properties, such as configuration of tools, reports, and other miscellaneous behavior.

To edit common Code Dx configuration, copy the existing `codedx.props` file locally with `kubectl cp {codedx-pod}:/opt/codedx/codedx.props "$PWD"`, make your changes to this file, and call `helm upgrade` with your changes:

```yaml
# values.yaml
codedxProps:
  file: my-codedx-props
```

```bash
# Direct call
helm upgrade {my-codedx} codedx/codedx --set codedxProps.file=my-codedx-props
```

## Sensitive Information

Some properties, such as MariaDB or LDAP connection information, is stored in Secrets instead. These Secrets contain similar `codedx.props`-formatted content, which are also mounted as files. The file paths are then passed to Code Dx and loaded during installation and startup.

Check the example file [for setting up LDAP configuration](../sample-values/values-ldap.yaml) for an example on how to load your own properties stored in a secret. Make your changes, and call `helm upgrade ...` with those changes.

If Code Dx does not restart automatically, use `kubectl delete {codedx-pod}` to force a restart and load your additional properties. Check the logs for the new pod to make sure that the file was successfully loaded - the log file should contain a message such as:

```
Loaded additional props file from <YOUR-PATH> using X syntax, based on the system property <YOUR-PARAM-NAME>.
```

## LDAP(s) and External Tools - cacerts

When configuring Code Dx to connect via LDAPS or an external tool, there are two considerations - accepting TLS certs and enabling egress from Code Dx to these services.

### cacerts

Java applications generally use a _cacerts_ file, which is a collection of certs used to authenticate peers. Any connection using TLS will reference the available certs in this file. For LDAPS and external tools using HTTPS, their cert may need to be imported into _cacerts_ for Code Dx to complete connections to those services. Information for installing a cert into a _cacerts_ file [can be found in the Code Dx Install Guide](https://codedx.com/Documentation/InstallGuide.html#TrustingSelfSignedCertificates). If a CA certificate is being installed, you may need to include the flag `-trustcacerts` for `keytool`. Note that, while that guide modifies the _cacerts_ file directly on the installed machine, you will be modifying a Secret instead that will be mounted as the _cacerts_ file within Code Dx.

This chart accepts a `cacertsFile` value, which is the path to a file on your local machine that will be stored in a Secret and mounted by Code Dx. When installing, you can use `--set cacertsFile=my/path/cacerts` to specify your _cacerts_ file. If changing the _cacerts_ file after installation, you should use `helm upgrade {my-codedx} codedx/codedx --set cacertsFile=my/path/updatedCacerts`. Using the `helm upgrade` command will automatically create a new (or modify an existing) secret with the contents of your _cacerts_ file. It will also update the Code Dx deployment to mount that secret appropriately. (Note that, if the _cacerts_ secret already exists, Code Dx will not see changes to the updated secret until it's restarted.)

You can get the current _cacerts_ file from an existing Code Dx container with:

```
kubectl cp <CODEDX-POD-NAME>:/etc/ssl/certs/java/cacerts .
```

### Egress

If NetworkPolicies are not in use in your cluster, this can be ignored. Otherwise, the network policy for the Code Dx container will need to permit egress on the appropriate ports (e.g. for connections to JIRA.) For well-known ports LDAP(s) and HTTP(s), you can update the network policy with:

```yaml
networkPolicy:
  codedx:
    ldap: true
    ldaps: true
    http: true
    https: true
```

```bash
# Direct call
helm upgrade {my-codedx} codedx/codedx \
    --set networkPolicy.codedx.ldap=true \
    --set networkPolicy.codedx.ldaps=true \
    --set networkPolicy.codedx.http=true \
    --set networkPolicy.codedx.https=true \
```

For any other ports, a new NetworkPolicy should be created for your needs.