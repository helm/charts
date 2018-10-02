# Distributed JMeter

Based on the work done [here](https://github.com/pedrocesar-ti/distributed-jmeter-docker).

Apache Jmeter™ is an open source tool that helps creating and running load test plans. This helm/chart was created to help you running different versions of JMeter in a distributed fashion (master -> server architecture), for more info.

## Chart Details:
This chart will do the following:
- Deploy a JMeter master (by default 1) that is responsible to store the test plans and test results after running on the servers.
- Deploy a JMeter server service (by default 3 replicas) that are responsible to run the actual test and send back the results to the master.


## Installing the Chart:
To install the chart with the release name jmeter:
```
$ helm install --name distributed-jmeter stable/distributed-jmeter
```

## Deploying different versions of JMeter
The default [image](https://hub.docker.com/r/pedrocesarti/jmeter-docker/) allows you to run JMeter in all versions available.

To change the version running on the helm you only need:
```
$ helm install --name distributed-jmeter --set master.image.tag=4.0 --set server.image.tag=4.0 stable/distributed-jmeter
```

Enjoy! :)
