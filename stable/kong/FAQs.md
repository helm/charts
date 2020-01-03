# Frequently Asked Questions (FAQs)

#### Kong fails to start after `helm upgrade` when Postgres is used. What do I do?

You may be running into this issue: https://github.com/helm/charts/issues/12575.
This issue is caused due to: https://github.com/helm/helm/issues/3053.

The problem that happens is that Postgres database has the old password but
the new secret has a different password, which is used by Kong, and password
based authentication fails.

The solution to the problem is to specify a password to the `postgresql` chart.
This is to ensure that the password is not generated randomly but is set to
the same one that is user-provided on each upgrade.

#### Kong fails to start on a fresh installation with Postgres. What do I do?

Please make sure that there is no `PersistentVolumes` present from a previous
release. If there are, it can lead to data or passwords being out of sync
and result in connection issues.

A simple way to find out is to use the following command:

```
kubectl get pv -n <your-namespace>
```

And then based on the `AGE` column, determine if you have an old volume.
If you do, then please delete the release, delete the volume, and then
do a fresh installation. PersistentVolumes can remain in the cluster even if
you delete the namespace itself (the namespace in which they were present).

