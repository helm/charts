# Change Log

This file documents all notable changes to sumologic-fluentd Helm Chart. 

NOTE: The change log until version 1.1.0 is auto generated based on git commits. Those include a reference to the git commit to be able to get more details.

## 1.1.0

Add support to configure affinity and nodeSelector. Signed-off-by… (#13129) 
commit: c6c091af4

## 1.0.0  

add apiVersion (#13837)
commit: 0973fdd51 

## 0.12.0  

Update fluentd-kubernetes-sumologic to the latest (v2.3.0) (#11329)
commit: 6342aa926 

## 0.11.0  

sumologic: add "extraEnv" for specifying custom env vars (#10837)
commit: e135c03e2 

## 0.10.1  

[stable/sumologic-fluentd] Fix render error if daemonset.priorityClassName not specified (#10698)
commit: 51bce0da1 

## 0.10.0  

[stable/sumologic-fluentd] Control adding time and stream via values (#9095)
commit: 76ad40cca 

## 0.9.0  

[stable/sumologic-fluentd] Support defining PriorityClass (#8748)
commit: 5da0256d9 

## 0.8.2  

[stable/sumlogic-fluentd] Supply collector URL via existing secret (#9583)
commit: e908cc5c0 

## 0.8.1  

[stable/sumologic-fluentd] Set node name to improve pod caching (#10148)
commit: 39bd2570f 

## 0.8.0  

Update to latest image, add OWNERS as well as add new owner to team, … (#10107)
commit: e8a363ffd 

## 0.7.0  

Upgrade fluentd-kubernetes-sumologic (#9305)
commit: bcc39fe26 

## 0.6.0  

[sumologic-fluentd] Update to latest image and expose new configuration to control stat watcher on fluentD in_tail plugins. (#6304)
commit: 63371a6d0 

## 0.5.0  

[stable/sumologic-fluentd] Upgrade to latest image and expose new configuration options in new image. (#5759)
commit: da113339e 

## 0.4.2  

[stable/sumologic-fluentd] typo fix: tables lists->table lists (#5711)
commit: d9902b7ea 

## 0.4.1  

[stable/sumologic-fluentd] Misc updates (#5338)
commit: 658fc4872 

## 0.4.0  

[stable/sumologic-fluentd] Allow the time_key field to be defined via environment variables (#4539)
commit: fb5ff1341 

## 0.3.3  

update document of sumologic-fluentd (#4921)
commit: a75d1ed02 

## 0.3.2  

only install daemonset if collectorUrl is set (#5235)
commit: 416a3b5ca 

## 0.3.1  

[stable/sumologic-fluentd] Support creating persistence directory (#3453)
commit: 5bd9c486a 

## 0.3.0  

[stable/sumologic-fluentd] Add support for user defined fluentd configuration (#3991)
commit: f534ef1ba 

## 0.2.1  

[stable/sumologic-fluentd] Update env variables (#3107)
commit: d968810a3 

## 0.2.0  

[stable/sumologic-fluented] add rbac and systemd (#1503)
commit: 2d851cdff 

## 0.1.1  

update trunc chars (#2059)
commit: 6c57dd219 

## 0.1.1  

[stable/sumologic-fluentd] Add daemon set 1.6 features (#1881)
commit: f46945b55 

## 0.1.0  

Spelling and Whitespace Corrections (#1853)
commit: a9ea2f4bf 

## 0.1.0  

[sumologic-fluentd] make rbac service account name configurable (#1722)
commit: d7a33f873 

## 0.1.0  

[stable/sumologic-fluentd] Add a container volumeMount mountPath /var/log/ (#1516)
commit: f7a2152cd 

## 0.1.0  

initial version of sumologic-fluentd (#913)
commit: bc597b899 
