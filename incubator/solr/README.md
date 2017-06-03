Solr
=============
This example runs Solr through a petset.

* This requires the zookeeper petset.
* Uses the official Solr docker image
* Creates persistent disks for the solr data

## Starting

    kubectl create -f solr.yaml

## Checking cluster status

    kubectl logs -f solr-1

    Starting Solr in SolrCloud mode on port 8983 from /opt/solr/server

    0    INFO  (main) [   ] o.e.j.u.log Logging initialized @270ms
    164  INFO  (main) [   ] o.e.j.s.Server jetty-9.3.8.v20160314
    181  INFO  (main) [   ] o.e.j.d.p.ScanningAppProvider Deployment monitor [file:///opt/solr/server/contexts/] at interval 0
    439  INFO  (main) [   ] o.e.j.w.StandardDescriptorProcessor NO JSP Support for /solr, did not find org.apache.jasper.servlet.JspServlet
    447  WARN  (main) [   ] o.e.j.s.SecurityHandler ServletContext@o.e.j.w.WebAppContext@6d7b4f4c{/solr,file:///opt/solr/server/solr-webapp/webapp/,STARTING}{/opt/solr/server/solr-webapp/webapp} has uncovered http methods for path: /
    ...
    ...
    1427 INFO  (zkCallback-4-thread-1-processing-n:100.96.1.5:8983_solr) [   ] o.a.s.c.c.ZkStateReader Updated live nodes from ZooKeeper... (1) -> (2)
    1501 INFO  (main) [   ] o.a.s.c.CoreContainer Security conf doesn't exist. Skipping setup for authorization module.
    1501 INFO  (main) [   ] o.a.s.c.CoreContainer No authentication plugin used.
    1554 INFO  (main) [   ] o.a.s.c.CorePropertiesLocator Looking for core definitions underneath /opt/solr/server/solr
    1556 WARN  (main) [   ] o.a.s.c.CorePropertiesLocator Error visiting /opt/solr/server/solr/data/lost+found: java.nio.file.AccessDeniedException: /opt/solr/server/solr/data/lost+found
    1561 INFO  (main) [   ] o.a.s.c.CorePropertiesLocator Found 0 core definitions
    1585 INFO  (main) [   ] o.a.s.s.SolrDispatchFilter user.dir=/opt/solr/server
    1585 INFO  (main) [   ] o.a.s.s.SolrDispatchFilter SolrDispatchFilter.init() done
    1594 INFO  (main) [   ] o.e.j.s.h.ContextHandler Started o.e.j.w.WebAppContext@6d7b4f4c{/solr,file:///opt/solr/server/solr-webapp/webapp/,AVAILABLE}{/opt/solr/server/solr-webapp/webapp}
    1598 INFO  (main) [   ] o.e.j.s.ServerConnector Started ServerConnector@480d3575{HTTP/1.1,[http/1.1]}{0.0.0.0:8983}
    1599 INFO  (main) [   ] o.e.j.s.Server Started @1869ms

## Failover

TODO: Add details

##  Scaling

TODO: Add details

## Image Upgrade

TODO: Add details

## Limitations
