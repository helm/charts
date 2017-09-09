# Portus Helm Chart

This Helm chart simplifies the deployment of a docker registry with access control managed by [Portus](http://port.us.org).

(Currently heavily tied to AWS S3 / Minio registry storage)

## To Do

* Re-add [registry-monitor](https://github.com/coreos/registry-monitor)
* Find a better way to manage Portus Admin user (and disable sign-ups)
* Find a way to auto-register the bundled registry
* Use `kube2iam` to manage registry access to S3 with roles instead of S3 keys

## Pre Requisites:

* Requires (and tested with) helm `v2.5.0` or above.
* Requires Ingress Controller with configurable `proxy-body-size` ([nginx-ingress](https://github.com/kubernetes/charts/tree/master/stable/nginx-ingress))
* Requires Let's Encrypt support for Ingress resources ([kube-lego](https://github.com/kubernetes/charts/tree/master/stable/kube-lego))

### Ingress Controller

-   Install an `nginx-ingress` controller with customizable `proxy-body-size`:

    ```
    echo '
    controller:
      config: {"proxy-body-size": "0"}
      image:
        tag: 0.9.0-beta.7
    ' | tee ingc-conf.yaml
    ```
    *Note*: This disables the default proxy body-size limit as an example set up, proceed with caution

    ```
    helm install stable/nginx-ingress -n ingc -f ingc-conf.yaml
    ```

    Ensure the Load Balancer managing the Ingress traffic has Aliases for the desired TLS ingress hosts.

    or use something like [kops/addons/route53-mapper](https://github.com/kubernetes/kops/tree/master/addons/route53-mapper) (and add labels to the nginx-ingress-controller service to automate Route53 records)

### Kube Lego

-   Install Kubernetes Let's Encrypt TLS manager for Ingress resources:

    ```
    helm install stable/kube-lego -n ing --set config.LEGO_EMAIL=user@example.com,config.LEGO_URL=https://acme-v01.api.letsencrypt.org/directory
    ```

### Registry with Minio

By default the Minio chart will be installed and used as storage for the Docker registry

### Registry S3 Bucket

Alternatively, s3 may be used as a backing registry:

Create a Bucket - with a `rootDirectory`:
```
export AWS_REGION=ap-southeast-1
export S3_BUCKET=docker-registry-example-com
aws s3 mb s3://${S3_BUCKET} --region ${AWS_REGION}
aws s3api put-object --bucket ${S3_BUCKET} --key portus/
```

Sample Policy:
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads"
      ],
      "Resource": "arn:aws:s3:::S3_BUCKET_NAME"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "arn:aws:s3:::S3_BUCKET_NAME/*"
    }
  ]
}
```
Ref: [Docker Registry docs](https://docs.docker.com/registry/storage-drivers/s3/)

## Chart details

This chart will do the following:

* Create Ingress resources with TLS support for both the docker registry and portus
* Conditionaly deploy Minio
* Conditionaly deploy Mariadb
* Create a Deployment for SUSE/Portus
* Create a Deployment for docker/registry with Portus webhooks and authentication integration

### Installing the chart

To install the chart with the release name `portus` in the default namespace:

```bash
helm install -n portus .
```

| Parameter                    | Description                          | Default                             |
| ---------------------------- | ------------------------------------ | ----------------------------------- |
| `nameOverride`               | Name                                 | `portus`                            |
| `portus.image.repository`    | Image and registry name              | `opensuse/portus`                   |
| `portus.image.tag`           | Container image tag                  | `2.2`                               |
| `portus.image.pullPolicy`    | Container image pullPolicy           | `IfNotPresent`                      |
| `portus.fqdn`                | Portus fully qualified domain name   | `portus.registry.example.com`       |
| `portus.config.*`            |[Portus Config](http://port.us.org/docs/Configuring-Portus.html)|see `values.yaml` |
| `portus.config.signup`                            | Allow guests to create accounts | `True`                |
| `portus.config.first_user_admin`                  | Make first signup admin         | `True`                |
| `portus.config.delete`                            | Allow delete                    | `True`                |
| `portus.config.display_name`                      | Split username from displayname | `False`               |
| `portus.config.gravatar`                          | Use Gravatar avatars            | `True`                |
| `portus.config.email.from`                        | Email from address              | `portus@example.com`  |
| `portus.config.email.name`                        | Email from name                 | `Portus`              |
| `portus.config.email.reply_to`                    | Email reply-to                  | `no-reply@example.com`|
| `portus.config.email.smtp.enabled`                | Email SMTP config               | `False`               |
| `portus.config.email.smtp.address`                | Email SMTP config               | `smtp.example.com`    |
| `portus.config.email.smtp.domain`                 | Email SMTP config domain        | `example.com`         |
| `portus.config.email.smtp.port`                   | Email SMTP config               | `587`                 |
| `portus.config.user_permission.change_visibility` | User Permissions                | `True`                |
| `portus.config.user_permission.manage_namespace`  | User Permissions                | `True`                |
| `portus.config.user_permission.manage_team`       | User Permissions                | `True`                |
| `portus.secrets.db.host`     | Mysql host                           | `portusdb-mariadb`                  |
| `portus.secrets.db.catalog`  | Mysql catalog                        | `portusdb`                          |
| `portus.secrets.db.username` | Mysql username                       | `portus`                            |
| `portus.secrets.email.smtp.user_name` | SMTP credentials if enabled | `-`                                 |
| `portus.secrets.email.smtp.password`  | SMTP credentials if enabled | `-`                                 |
| `registry.image.repository`  | Image and registry name              | `library/registry`                  |
| `registry.image.tag`         | Container image tag                  | `2.6.1`                             |
| `registry.image.pullPolicy`  | Container image pullPolicy           | `IfNotPresent`                      |
| `registry.fqdn`              | Registry fully qualified domain name | `docker.registry.example.com`       |
| `registry.config.s3.region`  | Registry s3 region for bucket        | `ap-southeast-1`                    |
| `registry.config.s3.bucket`  | Registry s3 bucket name              | `docker-registry-example-com`       |
| `registry.config.s3.rootDirectory`| Registry s3 directory in bucket | `/portus`                           |
| `registry.secrets.s3.access-key`  | Registry s3 key                 | `-`                                 |
| `registry.secrets.s3.secret-key`  | Registry s3 secret              | `-`                                 |

Specify parameters using `--set key=value[,key=value]` argument to `helm install` or pass in custom configuration with `-f` flag

```bash
helm install -n portus . \
  --namespace=kube-system \
  -f .secrets.yaml
```

## References:

- [Nordstrom/kube-registry](https://github.com/Nordstrom/kube-registry)
