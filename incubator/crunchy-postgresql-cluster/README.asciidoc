= Helm Examples - Crunchy Containers for PostgreSQL
Crunchy Data Solutions, Inc.
v1.2.4, {docdate}
image::crunchy_logo.png?raw=true[]

== Helm Example for Crunchy Postgres

This is an example of running the Crunchy Postgres containers
using the link://https://github.com/kubernetes/helm[Helm project]!  More examples of the Crunchy Containers
for Postgres can be found at the link:https://github.com/crunchydata/crunchy-containers/[github site].   This example will live eventually within the 
Kubernetes Chart project contributed link:https://github.com/kubernetes/charts/[examples].

This example will create the following in your Kubernetes cluster:

 * postgres master service
 * postgres replica service
 * postgres 9.5 master database (pod)
 * postgres 9.5 replica database (replication controller)

This example creates a simple Postgres streaming replication 
deployment with a master (read-write), and a single asyncronous
replica (read-only).  You can scale up the number of replicas
dynamically.

=== Installation

Install helm according to their github documentation
and then install the examples as follows:
....
helm install ./crunchy-postgres-cluster
....

=== Testing

After installing the Helm chart, you will see the following services:
....
kubectl get services
NAME              CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
crunchy-master    10.0.0.171   <none>        5432/TCP   1h
crunchy-replica   10.0.0.31    <none>        5432/TCP   1h
kubernetes        10.0.0.1     <none>        443/TCP    1h
....


It takes about a minute for the replica to begin replicating with the
master.  To test out replication, see if replication is underway
with this command, enter *password* for the password when prompted:
....
psql -h crunchy-master -U postgres postgres -c 'table pg_stat_replication'
....

If you see a line returned from that query it means the master is replicating
to the slave.  Try creating some data on the master:

....
psql -h crunchy-master -U postgres postgres -c 'create table foo (id int)'
psql -h crunchy-master -U postgres postgres -c 'insert into foo values (1)'
....

Then verify that the data is replicated to the slave:
....
psql -h crunchy-replica -U postgres postgres -c 'table foo'
....

You can scale up the number of read-only replicas by running
the following kubernetes command:
....
kubectl scale rc crunchy-replica --replicas=2
....

It takes 60 seconds for the replica to start and begin replicating
from the master.


== Legal Notices

Copyright © 2016 Crunchy Data Solutions, Inc.

CRUNCHY DATA SOLUTIONS, INC. PROVIDES THIS GUIDE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF NON INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.

Crunchy, Crunchy Data Solutions, Inc. and the Crunchy Hippo Logo are trademarks of Crunchy Data Solutions, Inc.

