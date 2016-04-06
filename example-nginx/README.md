# example-nginx

A small website delivered by two cooperating containers.

1. [git-sync](https://github.com/slack/git-sync) container which constantly polls a git repository
1. [nginx](https://hub.docker.com/_/nginx/) container which serves the website on port 80

By default, this Chart adds a ReplicationController and a Service. Service uses
NodePort, so installing this chart will not provision a LoadBalancer. Depending
on your Kubernetes cluster configuration you may need to add additional
configuration to access the example service.

## Chart Label Usage

* `app=example-nginx` is the only set of labels used by this Chart

## Configuration

Configure the git-sync container using the following environment variables:

* `GIT_SYNC_REPO`: https://github.com/slack/basic-site.git
* `GIT_SYNC_BRANCH`: master
* `GIT_SYNC_BRANCH`: master
* `GIT_SYNC_DEST`: /git
* `GIT_SYNC_DEST_MODE`: 0755
* `GIT_SYNC_WAIT`: 60

# Changelog

## [0.0.2] - 2015-10-29

- Add a Service definition.

## [0.0.1] - 2015-10-28

- Initial release.
