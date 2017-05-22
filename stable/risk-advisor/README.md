# risk-advisor
Risk advisor module for Kubernetes. This project is licensed under the terms of the Apache 2.0 license.

It allows you to check how the cluster state would change it the request of creating provided pods was accepted by Kubernetes.

## Risk advisor server
Usage:
* `--port` int                      Port to listen on (default 9997)
* `--simulator` int              Port on which simulator pod listens for requests (default 9998)
* `--simulatorStartupTimeout` int   Maximum ammount of time in seconds to wait for simulator pod to start running (default 90)
* `--simulatorRequestTimeout` int   Maximum ammount of time in seconds to wait for simulator to respond to request (default 60)

Endpoints:
 * `/advise`:
     * Accepts: a JSON table containing pod definitions
     * Returns: a JSON table of scheduling results. Each result contains:
       	 * `podName`: (string) Name of the relevant pod
         * `result`: (string) `Scheduled` if the pod would be successfully scheduled, `failedScheduling` otherwise
         * `message`: (string) Additional information about the result (e.g. nodes which were tried, or the reason why scheduling failed)
 * `/healthz`  Health check endpoint, responds with HTTP 200 if successful
