# Licenses

By default, Code Dx will be installed without a license. When you first navigate to Code Dx after installation, you will first be asked for a license. You can include a license during the installation process using the `license.file` and/or `license.secret` values. Note that this approach only applies for a new installation, and will have no effect afterwards. If a license is provided during installation, it must also be provided after each `helm upgrade` call.

## Using a File

If you have a Code Dx license file that you want to use, copy it to your current working directory and install Code Dx using helm:

```yaml
# values.yaml
license:
  file: my-codedx-license.lic
```

```bash
# Direct call
helm install codedx/codedx --name codedx --set license.file="my-codedx-license.lic"
```

Code Dx will create a Secret containing the contents of `my-codedx-license.lic`, which is mounted as a file and read by Code Dx during installation.

## Using a Pre-Existing Secret

This is the recommended method. Create a secret with your base64-encoded Code Dx license, and store that license in the `license.lic` key of that secret. Then you can reference that secret when installing or upgrading Code Dx:

```yaml
# values.yaml
license:
  secret: my-codedx-license-secret
```

```bash
# Direct call
helm install codedx/codedx --name {my-codedx} --set license.secret="my-codedx-license-secret"
```