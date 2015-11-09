# memcached

Memcached is a cache server. http://memcached.org/

This chart provides a replication controller that starts (by default) a
single Memcached server. Memcached's clustering model is very simple:
everything is done client-side.

## For Clustering

This project creates two memcached RCs, each with only one pod. To use
this cluster, an app should declare two services -- one for each RC.
Memcached clients should then be configured to use both services.

RCs are named `memcached-1` and `memcached-2`. Both are labeled with
`provider: memcached`. However, using that as your only label selector
will have undesirable consequences.

To add more memcached servers to the cluster, create additional RCs and
services.
