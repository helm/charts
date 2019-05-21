# ClamAV

##  An Open-Source antivirus engine for detecting trojans, viruses, malware & other malicious threats.

[ClamAV](https://www.clamav.net/) is the open source standard for mail gateway scanning software.
 Developed by [Cisco Talos](https://github.com/Cisco-Talos/clamav-devel). This Helm Chart uses the [MailU](https://github.com/Mailu/Mailu) Docker image.

## QuickStart

```bash
$ helm install stable/clamav --name foo --namespace bar
```

## Introduction

This chart bootstraps a ClamAV deployment and service on a Kubernetes cluster using the Helm Package manager.

## Prerequisites

- Kubernetes 1.4+
- PV provisioner support in the underlying infrastructure (optional)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/clamav
```

The command deploys ClamAV on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The configurable parameters of the ClamAV chart and
their descriptions can be seen in `values.yaml`. The [full documentation](https://www.clamav.net/documents/clam-antivirus-0-101-0-user-manual) contains more information about running ClamAV in docker.

> **Tip**: You can use the default [values.yaml](values.yaml)

## Memory Usage

ClamAV uses around 1 GB RAM.




# Virus Definitions

For ClamAV to work properly, both the ClamAV engine and the ClamAV Virus Database (CVD) must be kept up to date.

The virus database is usually updated many times per week.

Freshclam should perform these updates automatically. Instructions for setting up Freshclam can be found in the [ documentation](https://www.clamav.net/documents/clam-antivirus-0-101-0-user-manual) section.
If your network is segmented or the end hosts are unable to reach the Internet, you should investigate setting up a private local mirror. If this is not viable, you may use these direct [ download](https://www.clamav.net/downloads)
