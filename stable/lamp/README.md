# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# LAMP

Ever wanted to deploy a [LAMP Stack](https://en.wikipedia.org/wiki/LAMP_(software_bundle)) on Kubernetes?

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```console
$ helm install stable/lamp
```

## Introduction

This chart bootstraps a [LAMP Stack](https://en.wikipedia.org/wiki/LAMP_(software_bundle)) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
It was designed in a very modular and transparent way. Instead of using a custom built docker container running multiple services like apache and php-fpm inside with no control or overwatch of these processes from within kubernetes, this chart takes the approach of using one service per container.

The charts default configurations were made with performance in mind. By default PHP-FPM is enabled and communication between php and mysql as well as apache and php is realized over unix sockets.

By default the chart is exposed to the public via LoadBalancer IP but exposing the chart via an ingress controller is also supported. If a working [lego container](https://github.com/jetstack/kube-lego) is configured the chart supports creating lets encrypt certificates.

Setting up your website is easy, you can either use [git](#git-container) or [svn](#svn-container) to copy your repo into the pod or use [sftp](#sftp-container) or [webdav](#webdav-container) and simply transfer your files into the container. If you have a different method of setting up your website, you can [manually prepare](#manually-preparing-the-webroot-and-database) it inside of an init container before the services start.

Once you've set up your website, you'd like to have separate development environments for testing? Don't worry, with one additional setting you can [clone an existing release](#cloning-charts) without downtime using the [xtrabackup](https://www.percona.com/software/mysql-database/percona-xtrabackup) [init container](https://hub.docker.com/r/lead4good/xtrabackup/).

Official containers are used wherever possible ( namingly [php](https://hub.docker.com/_/php/), [apache](https://hub.docker.com/_/httpd/), [mysql](https://hub.docker.com/_/mysql/), [mariadb](https://hub.docker.com/_/mariadb/) and [percona](https://hub.docker.com/_/percona/) ) while the use of well established containers was anticipated otherwise ( [phpmyadmin/phpmyadmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/), [atmoz/sftp](https://hub.docker.com/r/atmoz/sftp/),
[openweb/git-sync](https://hub.docker.com/r/openweb/git-sync/) ) . To provide some of its unique features such as chart cloning and wordpress support some containers had to be newly created. All of those are hosted as automated builds on docker hub - with their respective sources on GitHub ([lead4good/init-wp](https://hub.docker.com/r/lead4good/init-wp/), [lead4good/svn-sync](https://hub.docker.com/r/lead4good/svn-sync/), [lead4good/webdav](https://hub.docker.com/r/lead4good/webdav/), [lead4good/xtrabackup](https://hub.docker.com/r/lead4good/xtrabackup/)).

## Prerequisites

- Kubernetes 1.7+
- LoadBalancer support or Ingress Controller

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/lamp
```

The command deploys the LAMP chart on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Examples

To try out one of the [examples](examples/). you can run, e.g. for wordpress:

```console
$ helm install -f examples/wordpress.yaml --name wordpress stable/lamp
```

Currently you can try the following examples:

* [examples/wordpress.yaml](examples/wordpress.yaml)
* [examples/wordpress-ingress-ssl.yaml](examples/wordpress-ingress-ssl.yaml)
* [examples/wordpress-php-ini.yaml](examples/wordpress-php-ini.yaml)
* [examples/drupal.yaml](examples/drupal.yaml)
* [examples/joomla.yaml](examples/joomla.yaml)
* [examples/joomla.yaml](examples/grav.yaml)
* [examples/owncloud.yaml](examples/owncloud.yaml)
* [examples/nextcloud.yaml](examples/nextcloud.yaml)

## Configuration

The following tables list the configurable parameters of the LAMP chart and their default values.

You can specify each of the parameters using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set init.clone.release=my-first-release-lamp,php.sockets=false,php.oldHTTPRoot=/var/www/my-website.com \
    stable/lamp
```

The above command sets up the chart to create its persistent contents by cloning its content from `my-first-release-lamp`, sets PHP socket communication to `false` and sets an old http root to compensate for absolute path file links

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/lamp
```

> **Tip**: You can use the default [values.yaml](values.yaml) file as a template

### Manually preparing the webroot and database

The manual init container enables you to manually pull a websites backup from somewhere and set it up inside the container before the chart is deployed. Set `init.manually.enabled` to `true` and connect to the container by replacing `example-com-lamp` and executing

```console
$ kubectl exec -it \
  $(kubectl get pods -l app=example-com-lamp --output=jsonpath={.items..metadata.name}) \
  -c init-manually /bin/bash
```

The container has the document root mounted at `/var/www/html` and the database directory mounted at `/var/lib/mysql` . The default manual init container is derived from the official [mysql](https://hub.docker.com/_/mysql/) container and can create and startup a mysql db by setting the necessary environment variables and then executing

```console
$ /entrypoint.sh mysqld &
```

If another flavor of DB is used ([mariadb](https://hub.docker.com/_/mariadb/) or [percona](https://hub.docker.com/_/percona/)) then the image needs to be pointing to the right container.

After setting up your DB backup you can stop the database by executing
```console
$ mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD shutdown
```

Now copy all necessary files into the web directory, but do not forget to recursively chown the webroot to the `www-data` user ( id 33 ) by executing

```console
$ chown -R 33:33 /var/www/html
```

Once everything is setup stopping the init container is done by executing
```console
$ im-done
```

| Parameter | Description | Default |
| - | - | - |
| `init.manually.enabled` | Enables container for manual initialization | false |
| `init.manually.repository` | Containers image | lead4good/init-wp |
| `init.manually.tag` | Containers image tag | latest |
| `init.manually.pullPolicy` | Image pull policy | Always |

### Cloning charts

If `init.clone.release` is set to the fullname of an existing, already running LAMP chart (e.g. `example-com-lamp`), the persistent storage of that chart (web files and db) will be copied to this charts persistent storage. It is mandatory that both database containers are of the same type ([mysql](https://hub.docker.com/_/mysql/), [mariadb](https://hub.docker.com/_/mariadb/) or [percona](https://hub.docker.com/_/percona/)). Mixing them will not work.

| Parameter | Description | Default |
| - | - | - |
| `init.clone.release` | Fullname of the release to clone | _empty_ |
| `init.clone.hostPath` | If the release to clone uses hostPath instead of PVC, set it here. This will only work if both releases are deployed on the same node | _empty_ |

### Init Containers Resources

| `init.resources` | init containers resource requests/limits | `resources` |

### PHP and HTTPD Containers

The PHP container is at the heart of the LAMP chart. By default, the LAMP chart uses the official PHP container from docker hub. You can also use your own PHP container, which needs to have the official PHP container at its base.
FPM is enabled by default, this creates an additional HTTPD container which routes PHP request via FCGI to the PHP container. Set `php.fpmEnabled` to false to work with the official `php:apache` image.

> **Note**: If you are using a custom container, be sure to use the official `php:apache` or `php:fpm` containers at its base and set `php.fpmEnabled` accordingly

| Parameter | Description | Default |
| - | - | - |
| `php.repository` | default php image | php |
| `php.tag` | default php image tag | 7-fpm-alpine |
| `php.pullPolicy` | Image pull policy | Always |
| `php.fpmEnabled` | Enables FPM functionality, be sure to disable if working with a custom repository based on the apache tag | true |
| `php.sockets` | If FPM is enabled, enables communication between HTTPD and PHP via sockets instead of TCP | true |
| `php.oldHTTPRoot` | Additionally mounts the webroot at `php.oldHTTPRoot` to compensate for absolute path file links  | _empty_ |
| `php.ini` | additional PHP config values, see examples on how to use | _empty_ |
| `php.fpm` | addditonal PHP FPM config values | _empty_ |
| `php.copyRoot` | if true, copies the containers web root `/var/www/html` into persistent storage. This must be enabled, if the container already comes with files installed to `/var/www/html`  | false |
| `php.persistentSubpaths` | instead of enabling persistence for the whole webroot, only subpaths of webroot can be enabled for persistence. Have a look at the [nextcloud example](examples/nextcloud.yaml) to see how it works | _empty_ |
| `php.resources` | PHP container resource requests/limits | `resources` |
| `httpd.repository` | default httpd image if fpm is enabled | httpd |
| `httpd.tag` | default httpd image tag | 2.4-alpine |
| `httpd.resources` | HTTPD container resource requests/limits | `resources` |

### MySQL Container

The MySQL container is disabled by default, any container with the base image of the official [mysql](https://hub.docker.com/_/mysql/), [mariadb](https://hub.docker.com/_/mariadb/) or [percona](https://hub.docker.com/_/percona/) should work.

| Parameter | Description | Default |
| - | - | - |
| `mysql.rootPassword` | Sets the MySQL root password, enables MySQL service if not empty | _empty_ |
| `mysql.user` | MySQL user | _empty_ |
| `mysql.password` | MySQL user password | _empty_ |
| `mysql.database` | MySQL user database | _empty_ |
| `mysql.repository` | MySQL image - choose one of the official [mysql](https://hub.docker.com/_/mysql/), [mariadb](https://hub.docker.com/_/mariadb/) or [percona](https://hub.docker.com/_/percona/) images | mysql |
| `mysql.tag` | MySQL image tag | 5.7 |
| `mysql.imagePullPolicy` | Image pull policy | Always |
| `mysql.sockets` | Enables communication between MySQL and PHP via sockets instead of TCP | true |
| `mysql.resources` | Resource requests/limits | `resources` |

### SFTP Container

SFTP is an instance of the atmoz/sftp container, through which you can access the webroot.

> **Note**: The webroot is located in the subfolder of the sftp users home directory so putting files into the webroot via sftp have to be put to the web subfolder and the put command will fail if you upload to the root directory since writing permissions are disabled there.

> **Note**: using a different image than the default atmoz/sftp will most probably not work since the containers startup command is overwritten to be able to configure the sftp user, you may however change the tag to a different version without any problems

| Parameter | Description | Default |
| - | - | - |
| `sftp.repository` | default sftp image | atmoz/sftp |
| `sftp.tag` | default sftp image tag | alpine |
| `sftp.enabled` | Enables sftp service | false |
| `sftp.serviceType` | Type of sftp service in Ingress mode | NodePort |
| `sftp.port` | Port to advertise service in LoadBalancer mode | 22 |
| `sftp.nodePort` |  Port to advertise service in Ingress mode| _empty_ |
| `sftp.user` | SFTP User | _empty_ |
| `sftp.password` | SFTP Password | _empty_ |
| `sftp.resources` | resource requests/limits | `resources` |

### WebDAV Container

An instance of WebDAV, through which you can access the webroot.

| Parameter | Description | Default |
| - | - | - |
| `webdav.enabled` | Enables webdav service | false |
| `webdav.port` | Port to advertise service in LoadBalancer mode | 8001 |
| `webdav.subdomain` | Subdomain to advertise service on if ingress is enabled | webdav |
| `webdav.user` | WebDAV User | _empty_ |
| `webdav.password` | WebDAV Password | _empty_ |
| `webdav.resources` | resource requests/limits | `resources` |

### Git Container

If Git is enabled, the contents of the specified repository will be synchronized every `git.wait` seconds to the web root. The web root needs to be empty otherwise the container will fail exit.

> **Note**: You should not combine SFTP or WebDAV with the Git container since this might cause confusion if someone edits a file via SFTP just to find out that its changes got reverted by the Git sync process

| Parameter | Description | Default |
| - | - | - |
| `git.enabled` | Enables Git service | false |
| `git.repoURL` | Git Repository URL | _empty_ |
| `git.branch` | Repository branch to sync | master |
| `git.revision` | Revision to sync | FETCH_HEAD |
| `git.wait` | Time between Git syncs | 30 |
| `git.resources` | resource requests/limits | `resources` |

### SVN Container

If SVN is enabled, the contents of the specified repository will be synchronized every 30 seconds to the web root. If allowOverwrite is disabled and files already exist in the web folder then it will not create a working clone or sync files.

> **Note**: You should not combine SFTP or WebDAV with the SVN container since this might cause confusion if someone edits a file via SFTP just to find out that its changes got reverted by the SVN sync process

| Parameter | Description | Default |
| - | - | - |
| `svn.enabled` | Enables svn service | false |
| `svn.user` | SVN User | _empty_ |
| `svn.password` | SVN Password | _empty_ |
| `svn.repoURL` | SVN Repository URL | _empty_ |
| `svn.allowOverwrite` | if disabled and files already exist in the web folder will not create working clone or sync files | true |
| `svn.resources` | resource requests/limits | `resources` |

### PHPMyAdmin Container

An instance of PHPMyAdmin through which you can access the database.

> **Note**: using a different image than the default phpmyadmin/phpmyadmin image might not work since the containers startup command is overwritten to be able to advertise the http services on `phpmyadmin.port`, you may however change the tag to a different version without any problems

| Parameter | Description | Default |
| - | - | - |
| `phpmyadmin.repository` | default phpmyadmin image | phpmyadmin |
| `phpmyadmin.tag` | default phpmyadmin image tag | phpmyadmin |
| `phpmyadmin.enabled` | Enables phpmyadmin service | false |
| `phpmyadmin.port` | Port to advertise service in LoadBalancer mode | 8080 |
| `phpmyadmin.subdomain` | Subdomain to advertise service on if ingress is enabled | phpmyadmin |
| `phpmyadmin.resources` | resource requests/limits | `resources` |

### Default Resources

Default resources are used by all containers which have no custom resources configured.

| Parameter | Description | Default |
| - | - | - |
| `resources.requests.cpu` | CPU resource requests | 1 |
| `resources.requests.memory` | Memory resource requests | 1Mi |
| `resources.limits.cpu` | CPU resource limits | _empty_ |
| `resources.limits.memory` | Memory resource limits | _empty_ |

### Persistence

If `persistence` is enabled, PVC's will be used to store the web root and the db root. If a pod then is redeployed to another node, it will restart within seconds with the old state prevailing. If it is disabled, `EmptyDir` is used, which would lead to deletion of the persistent storage once the pod is moved. Also cloning a chart with `persistence` disabled will not work. Therefor persistence is enabled by default and should only be disabled in a testing environment. In environments where no PVCs are available you can use `persistence.hostPath` instead. This will store the charts persistent data on the node it is running on.

| Parameter | Description | Default |
| - | - | - |
| `persistence.enabled` | Enables persistent volume - PV provisioner support necessary | true |
| `persistence.keep` | Keep persistent volume after helm delete | false |
| `persistence.accessMode` | PVC Access Mode | ReadWriteOnce |
| `persistence.size` | PVC Size | 5Gi |
| `persistence.storageClass` | PVC Storage Class | _empty_ |
| `persistence.hostPath` | if specified, used as persistent storage instead of PVC | _empty_ |

### Network

To be able to connect to the services provided by the LAMP chart, a Kubernetes cluster with working LoadBalancer or Ingress Controller support is necessary.
By default the chart will create a LoadBalancer Service, all services will be available via LoadBalancer IP through different ports. You can set `service.type` to ClusterIP if you do not want your chart to be exposed at all.
If `ingress.enabled` is set to true, the LAMP charts services are made accessible via ingress rules. Those services which are not provided by HTTP protocol via `nodePorts`. In ingress mode the LAMP chart also supports ssl with certificates signed by lets encrypt. This requires a working [lego](https://github.com/jetstack/kube-lego) container running on the cluster.

> **Note**: In ingress mode it is mandatory to set `ingress.domain`, otherwise the ingress rules won't know how to route the traffic to the services.

| Parameter | Description | Default |
| - | - | - |
| `service.type` | Changes to ClusterIP automatically if ingress enabled | LoadBalancer |
| `service.HTTPPort` | Port to advertise the main web service in LoadBalancer mode | 80 |
| `ingress.enabled` | Enables ingress support - working ingress controller necessary | false |
| `ingress.domain` | domain to advertise the services - A records need to point to ingress controllers IP | _empty_ |
| `ingress.subdomainWWW` | enables www subdomain and 301 redirect from domain. Requires nginx ingress controller. | false |
| `ingress.ssl` | Enables [lego](https://github.com/jetstack/kube-lego) letsencrypt ssl support - working nginx controller and lego container necessary | false |
| `ingress.htpasswdString` | if specified main web service requires authentication. Requires nginx ingress controller. Format: _user:$apr1$F..._ | _empty_ |
| `ingress.annotations` | specify custom ingress annotations such as e.g. `ingress.kubernetes.io/proxy-body-size` |  |

### Wordpress


The LAMP chart offers additional wordpress features during the init stage. It supports two modes, normal mode sets up the chart completely automatic by downloading an InfiniteWP backup from google drive, while the other mode gets executed when in manual mode (see: `init.manually`). While in manual mode, the web files and db backup need to be manually downloaded and stashed in the appropriate folders (`/var/www/html` <-- web root, `/var/www/mysql` <-- sql backup). The automatic mode does this automatically. Both modes then import the backup and do some necesssary config file changes. So even in manual mode it is not necessary to import the db backup.

In development mode everything that gets executed in normal mode will also get executed. Additionally the wordpress domain is automatically search replaced inside the database. Also the `wp_content/uploads` and `wp_content/cache` directories are deleted. The `.htaccess` file is modified to redirect requests to the uploads directory to the uploads directory of `wordpress.domain`.

| Parameter | Description | Default |
| - | - | - |
| `wordpress.enabled` | Enables wordpress normal mode | false |
| `wordpress.gdriveRToken` | gdrive rtoken for authentication used for downloading InfiniteWP backup from gdrive | _empty_ |
| `wordpress.gdriveFolder` | gdrive backup folder - the latest backup inside of the folder where the name includes the string `_full` will be downloaded | `wordpress.domain` |
| `wordpress.domain` | wordpress domain used in dev mode to be search replaced | _empty_ |
| `wordpress.develop.enabled` | enables develop mode | false |
| `wordpress.develop.deleteUploads` | deletes `wp_content/uploads` folder and links to live site within htaccess | false |
| `wordpress.develop.devDomain` | used to search replace `wordpress.domain` to `fullname of template`.`develop.devDomain` e.g `mysite-com-lamp.dev.example.com` | _empty_ |

### Other

| Parameter | Description | Default |
| - | - | - |
| `keepSecrets` | Keep secrets after helm delete | false |
| `replicaCount` | > 1 will corrupt your database if one is used. Future releases might enable elastic scaling via galeradb | 1 |
