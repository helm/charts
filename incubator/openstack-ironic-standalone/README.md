Openstack Ironic Standalone
===========================

[Openstack Ironic](https://docs.openstack.org/ironic/latest/index.html), Ironic is an OpenStack project which provisions bare metal (as opposed to virtual) machines. It may be used independently or as part of an OpenStack Cloud, and integrates with the OpenStack Identity (keystone), Compute (nova), Network (neutron), Image (glance), and Object (swift) services.

This Helm chart installs Openstack Ironic in [standalone mode](https://docs.openstack.org/ironic/latest/install/standalone.html).

TL;DR;

Create a config file (`my-site.yaml`) with following variables defined:
```
---
ironicServerName: example.example.io
persistentVolumeClaimName: existing-claim-name
api:
  externalIPs:
    - 10.10.10.10
httpboot:
  externalIPs:
    - 10.10.10.10
tftp:
  externalIPs:
    - 10.10.10.10
mysql:
  mysqlPassword: secret1
  mysqlRootPassword: secret2
  persistence:
    existingClaim: existing-claim-name
rabbitmq:
  rabbitmq:
    password: secret3
```

Then install a chart using command:
```
helm install incubator/openstack-standalone-ironic -f my-site.yaml
```

Configuration
=============

All configuration parameters are documented in the `values.yaml` file.

Comparison to [Kolla](https://docs.openstack.org/ironic/latest/install/standalone.html)
=======================================================================================

Kolla provides a method to deploy a full Openstack suite. This chart installs only Openstack Ironic.
The chart has a *minimalistic* approach.

Why minimalistic?
-----------------
* Uses simple Docker images with no sophisticated entrypoints. Docker images are from Openstack rpms packaged by CentOS.
* Depending services like MySQL, Rabbitmq are installed from production Helm charts

Storage
=======

The chart uses an existing volume claim. It does not create any claims.
It uses `subPath` functionality to create sub directories on the existing claim.
The existing claim name must be defined in two places: `persistentVolumeClaimName` and `mysql.persistence.existingClaim`.

Note on tftpd
=============

Tftp protocol does not fit to Kubernetes network model.
Here is how it works:
```
Client:x → Srv:69 - client requests
Client:x ← Srv:y - server replies from a random port, not 69
Client:x → Srv:y - client acknowledges on dedicated port
```

Some charts use ptftp instead, but we were not able to enable it:
* it had too many bugs and we were not able to transfer large files using it

That's why we start in.tftpd DaemonSet with hostNetwork enabled.
It means that we have a pool of servers running in.tftpd.
Only the one that has the external IP address attached will be serving files.
It does not use a Kubernetes network model (POD network, service network).
