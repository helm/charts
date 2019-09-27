# k8s-community-grid

## Helm
Helm chart is used as follows:

```
helm install k8s-community-grid -n k8s-community-grid --namespace community-workers
```
Optional values you may wish apply with `--set` 
- limits.cpu=4000m
- limits.memory=4096m
- requests.cpu=200m
- requests.memory=512m
- project="BoincProjectURL"
- accountKey="YourAccountKey"
- http_server_name: '""'
- http_server_port: '""'
- http_user_name: '""'
- http_user_passwd: '""'
- socks_server_name: '""'
- socks_server_port: '""'
- socks_version: '""'
- socks5_user_name: '""'
- socks5_user_passwd: '""'


## Want to do alternative community work?
k8s-community-grid can be used for all boinc projects such as; Rosetta@Home, LHC@Home, Seti@Home etc. 

All you need do is use the helm chart `project="BoincProjectURL",accountKey="YourAccountKey"`


## Thanks for joining the fight
Early and accurate detection saves lives.

Power the search for molecular markers that will help researchers detect cancer earlier and design more effective treatments.

https://www.worldcommunitygrid.org/

## Troubleshooting
To get logs for all Pods

```
 kubectl logs -f -l app=k8s-community-grid --all-containers -n community-workers
```
