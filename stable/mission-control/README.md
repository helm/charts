# JFrog Mission-Control Helm Chart - DEPRECATED
**This chart is deprecated! You can find the new chart in:**
- **Sources:** https://github.com/jfrog/charts
- **Charts repository:** https://charts.jfrog.io
```bash
helm repo add jfrog https://charts.jfrog.io
```

## Prerequisites Details

* Kubernetes 1.8+

## Chart Details
This chart will do the following:

* Deploy Mongodb database.
* Deploy Elasticsearch.
* Deploy Mission Control.

## Requirements
- A running Kubernetes cluster
- Dynamic storage provisioning enabled
- Default StorageClass set to allow services using the default StorageClass for persistent storage
- A running Artifactory Enterprise
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and setup to use the cluster
- [Helm](https://helm.sh/) installed and setup to use the cluster (helm init)

## Create Secret with keys and certs for Mission-Control

* Create file `generate_keys.sh` with following content:

```bash
#!/bin/bash
set -e

usage() {
    echo "Usage: $0 [store_password]"
    exit 1
}

processCommandLine() {
    if [[ "$1" =~ (help|-h|--help) ]]; then
        usage
    fi

    # Set password if not passed
    if [ -z "$1" ]; then
        echo "No password passed. Generating a random one..."
        storePassword=$(cat /dev/urandom | env LC_CTYPE=C tr -cd 'a-f0-9' | head -c 16)
    else
        storePassword=$1
    fi
}

# Check if key generation tools are available
checkTools() {
    echo "Checking if required tools exist"
    for tool in "keytool" "openssl"; do
        echo "${tool}"
        hash ${tool} 2>/dev/null
    done
}

# Create the file system structure
createCertsDir() {
    tmpDir=./certs
    jfmcSecurity=${tmpDir}/mission-control/etc/security
    insightSecurity=${tmpDir}/insight-server/etc/security
    echo "Generating certs in ${tmpDir}"
    if [ -d ${tmpDir} ]; then
        echo "Found existing ${tmpDir}. Backing it up to ${tmpDir}-${timeStamp}..."
        mv ${tmpDir} ${tmpDir}-${timeStamp}
    fi

    mkdir -pv ${jfmcSecurity} ${insightSecurity}
}

genJfmcKeyStore() {
    keytool -genkeypair -alias secure-jfmc -keyalg RSA \
          -dname "CN=*,OU=JFMC,O=JFrog,L=Toulouse,S=France,C=fr" \
          -keystore ${tmpDir}/jfmc-keystore.jks \
          -storepass ${storePassword} \
          -keypass ${storePassword}

    keytool -exportcert -alias secure-jfmc \
          -file ${tmpDir}/jfmc-public.cer \
          -keystore ${tmpDir}/jfmc-keystore.jks \
          -storepass ${storePassword}

    keytool -importkeystore \
          -srcalias secure-jfmc \
          -srckeystore ${tmpDir}/jfmc-keystore.jks \
          -destkeystore ${tmpDir}/jfmc-keystore.p12 \
          -deststoretype PKCS12 \
          -srckeypass ${storePassword} \
          -srcstorepass ${storePassword} \
          -deststorepass ${storePassword}

    openssl pkcs12 -in ${tmpDir}/jfmc-keystore.p12 \
                 -nokeys \
                 -nodes \
                 -out ${tmpDir}/jfmc.crt \
                 -password pass:${storePassword} \
                 -passin pass:${storePassword}
}

genInsightKeyStore() {
    keytool -genkeypair -alias secure-insight -keyalg RSA \
          -dname "CN=*,OU=Insight,O=JFrog,L=Bengaluru,S=Kan,C=in" \
          -keystore ${tmpDir}/insight-keystore.jks \
          -storepass ${storePassword} \
          -keypass ${storePassword}

    keytool -exportcert -alias secure-insight \
          -file ${tmpDir}/insight-public.cer \
          -keystore ${tmpDir}/insight-keystore.jks \
          -storepass ${storePassword}

    keytool -importkeystore \
          -srcalias secure-insight \
          -srckeystore ${tmpDir}/insight-keystore.jks \
          -destkeystore ${tmpDir}/insight-keystore.p12 \
          -deststoretype PKCS12 \
          -noprompt \
          -srckeypass ${storePassword} \
          -srcstorepass ${storePassword} \
          -deststorepass ${storePassword}


    openssl pkcs12 -in ${tmpDir}/insight-keystore.p12 \
                 -nocerts \
                 -nodes \
                 -out ${tmpDir}/insight.key \
                 -password pass:${storePassword} \
                 -passin pass:${storePassword}
    openssl pkcs12 -in ${tmpDir}/insight-keystore.p12 \
                 -nokeys \
                 -nodes \
                 -out ${tmpDir}/insight.crt \
                 -password pass:${storePassword} \
                 -passin pass:${storePassword}
}

importInTrustStore() {
    keytool -importcert -keystore ${tmpDir}/jfmc-truststore.jks \
          -alias insightcert \
          -noprompt \
          -file ${tmpDir}/insight-public.cer \
          -storepass ${storePassword}

    keytool -importcert -keystore ${tmpDir}/insight-truststore.jks \
          -alias jfmccert \
          -noprompt \
          -file ${tmpDir}/jfmc-public.cer \
          -storepass ${storePassword}
}

# Put the generated files in their intended structure
arrangeFiles() {
    echo "Moving certs to their final location"
    mv -f ${tmpDir}/jfmc-truststore.jks ${jfmcSecurity}
    mv -f ${tmpDir}/jfmc-keystore.jks ${jfmcSecurity}
    mv -f ${tmpDir}/jfmc.crt ${insightSecurity}
    mv -f ${tmpDir}/insight-truststore.jks ${insightSecurity}
    mv -f ${tmpDir}/insight-keystore.jks ${insightSecurity}
    mv -f ${tmpDir}/insight.key ${insightSecurity}
    mv -f ${tmpDir}/insight.crt ${insightSecurity}
    cat ${jfmcSecurity}/jfmc-truststore.jks | base64 > ${jfmcSecurity}/jfmc-truststore.jks-b64
    cat ${jfmcSecurity}/jfmc-keystore.jks | base64 > ${jfmcSecurity}/jfmc-keystore.jks-b64
}

summary() {
    echo -e "\nAll keys and certificates are ready!"
    echo -e "\n- Mission Control files"
    find ${jfmcSecurity} -type f
    echo -e "\n- Insight Server files"
    find ${insightSecurity} -type f
}

############ Main ############

echo -e "\nCreating keys and certificates for JFrog Mission Control"
echo "========================================================"

timeStamp=$(date +%Y%m%d-%H%M%S)

processCommandLine $*
checkTools
createCertsDir
genInsightKeyStore
genJfmcKeyStore
importInTrustStore
arrangeFiles
summary
echo -e "========================================================\n"
```
* Run `./generate_keys.sh` to create certs and keys.

* Create secret for certs and keys
```bash
kubectl create secret generic mission-control-certs --from-file=./certs/insight-server/etc/security/insight.key --from-file=./certs/insight-server/etc/security/insight.crt --from-file=./certs/insight-server/etc/security/jfmc.crt  --from-file=./certs/mission-control/etc/security/jfmc-truststore.jks-b64 --from-file=./certs/mission-control/etc/security/jfmc-keystore.jks-b64
```

### Installing the Chart with certificate secret
```bash
helm install --name mission-control --set existingCertsSecret=mission-control-certs stable/mission-control
```

## Set Mission Control base URL
* Get mission-control url by running following commands:
`export SERVICE_IP=$(kubectl get svc --namespace default mission-control-mission-control -o jsonpath='{.status.loadBalancer.ingress[0].ip}')`

`export MISSION_CONTROL_URL="http://$SERVICE_IP:8080/"`

* Set mission-control by running helm upgrade command:
```
helm upgrade --name mission-control --set existingCertsSecret=mission-control-certs --set missionControl.missionControlUrl=$MISSION_CONTROL_URL stable/mission-control
```

### Accessing Mission Control
**NOTE:** It might take a few minutes for Mission Control's public IP to become available, and the nodes to complete initial setup.
Follow the instructions outputted by the install command to get the Distribution IP and URL to access it.

### Updating Mission Control
Once you have a new chart version, you can update your deployment with
```
helm upgrade mission-control stable/mission-control
```

## Configuration

The following table lists the configurable parameters of the distribution chart and their default values.

|         Parameter                            |           Description                           |          Default                      |
|----------------------------------------------|-------------------------------------------------|---------------------------------------|
| `initContainerImage`                         | Init Container Image                            | `alpine:3.6`                          |
| `imagePullPolicy`                            | Container pull policy                           | `IfNotPresent`                        |
| `imagePullSecrets`                           | Docker registry pull secret                     |                                       |
| `serviceAccount.create`                      | Specifies whether a ServiceAccount should be created | `true`                           |
| `serviceAccount.name`                        | The name of the ServiceAccount to create             | Generated using the fullname template |
| `rbac.create`                                | Specifies whether RBAC resources should be created   | `true`                           |
| `rbac.role.rules`                            | Rules to create                                 | `[]`                                  |
| `mongodb.enabled`                            | Enable Mongodb                                  | `true`                                |
| `mongodb.image.tag`                          | Mongodb docker image tag                        | `3.6.3`                               |
| `mongodb.image.pullPolicy`                   | Mongodb Container pull policy                   | `IfNotPresent`                        |
| `mongodb.persistence.enabled`                | Mongodb persistence volume enabled              | `true`                                |
| `mongodb.persistence.existingClaim`          | Use an existing PVC to persist data             | `nil`                                 |
| `mongodb.persistence.storageClass`           | Storage class of backing PVC                    | `generic`                             |
| `mongodb.persistence.size`                   | Mongodb persistence volume size                 | `50Gi`                                |
| `mongodb.livenessProbe.initialDelaySeconds`  | Mongodb delay before liveness probe is initiated   | `40`                               |
| `mongodb.readinessProbe.initialDelaySeconds` | Mongodb delay before readiness probe is initiated  | `30`                               |
| `mongodb.mongodbExtraFlags`                  | MongoDB additional command line flags           | `["--wiredTigerCacheSizeGB=1"]`       |
| `mongodb.usePassword`                        | Enable password authentication                  | `false`                               |
| `mongodb.db.adminUser`                       | Mongodb Database Admin User                     | `admin`                               |
| `mongodb.db.adminPassword`                   | Mongodb Database Password for Admin user        | ` `                                   |
| `mongodb.db.mcUser`                          | Mongodb Database Mission Control User           | `mission_platform`                    |
| `mongodb.db.mcPassword`                      | Mongodb Database Password for Mission Control user | ` `                                |
| `mongodb.db.insightUser`                     | Mongodb Database Insight User                   | `jfrog_insight`                       |
| `mongodb.db.insightPassword`                 | Mongodb Database password for Insight User      | ` `                                   |
| `mongodb.db.insightSchedulerDb`              | Mongodb Database for Scheduler                  | `insight_scheduler`                   |
| `elasticsearch.enabled`                      | Enable Elasticsearch                            | `true`                                |
| `elasticsearch.persistence.enabled`          | Elasticsearch persistence volume enabled        | `true`                                |
| `elasticsearch.persistence.existingClaim`    | Use an existing PVC to persist data             | `nil`                                 |
| `elasticsearch.persistence.storageClass`     | Storage class of backing PVC                    | `generic`                             |
| `elasticsearch.persistence.size`             | Elasticsearch persistence volume size           | `50Gi`                                |
| `elasticsearch.env.clusterName`              | Elasticsearch Cluster Name                      | `es-cluster`                          |
| `elasticsearch.env.esUsername`               | Elasticsearch User Name                         | `elastic`                             |
| `elasticsearch.env.esPassword`               | Elasticsearch User Name                         | `changeme`                            |
| `existingCertsSecret`                        | Mission Control certificate secret name         |                                       |
| `missionControl.name`                        | Mission Control name                            | `mission-control`                     |
| `missionControl.replicaCount`                | Mission Control replica count                   | `1`                                   |
| `missionControl.image`                       | Container image                                 | `docker.jfrog.io/jfrog/mission-control`     |
| `missionControl.version`                     | Container image tag                             | `3.1.2`                               |
| `missionControl.service.type`                | Mission Control service type                    | `LoadBalancer`                        |
| `missionControl.externalPort`                | Mission Control service external port           | `80`                                  |
| `missionControl.internalPort`                | Mission Control service internal port           | `8080`                                |
| `missionControl.missionControlUrl`           | Mission Control URL                             | ` `                                   |
| `missionControl.persistence.mountPath`       | Mission Control persistence volume mount path   | `"/var/opt/jfrog/mission-control"`    |
| `missionControl.persistence.storageClass`    | Storage class of backing PVC                    | `nil (uses alpha storage class annotation)` |
| `missionControl.persistence.existingClaim`   | Provide an existing PersistentVolumeClaim       | `nil`                                 |
| `missionControl.persistence.enabled`         | Mission Control persistence volume enabled      | `true`                                |
| `missionControl.persistence.accessMode`      | Mission Control persistence volume access mode  | `ReadWriteOnce`                       |
| `missionControl.persistence.size`            | Mission Control persistence volume size         | `100Gi`                               |
| `missionControl.javaOpts.other`              | Mission Control JAVA_OPTIONS                    | `-server -XX:+UseG1GC -Dfile.encoding=UTF8` |
| `missionControl.javaOpts.xms`                | Mission Control JAVA_OPTIONS -Xms               | `1g`                                  |
| `missionControl.javaOpts.xmx`                | Mission Control JAVA_OPTIONS -Xmx               | `2g`                                  |
| `insightServer.name`                         | Insight Server name                             | `insight-server`                      |
| `insightServer.replicaCount`                 | Insight Server replica count                    | `1`                                   |
| `insightServer.image`                        | Container image                                 | `docker.jfrog.io/jfrog/insight-server`|
| `insightServer.version`                      | Container image tag                             | `3.1.2`                               |
| `insightServer.service.type`                 | Insight Server service type                     | `ClusterIP`                           |
| `insightServer.externalHttpPort`             | Insight Server service external port            | `8082`                                |
| `insightServer.internalHttpPort`             | Insight Server service internal port            | `8082`                                |
| `insightServer.externalHttpsPort`            | Insight Server service external port            | `8091`                                |
| `insightServer.internalHttpsPort`            | Insight Server service internal port            | `8091`                                |
| `insightScheduler.name`                      | Insight Scheduler name                          | `insight-scheduler`                   |
| `insightScheduler.replicaCount`              | Insight Scheduler replica count                 | `1`                                   |
| `insightScheduler.image`                     | Container image                                 | `docker.jfrog.io/jfrog/insight-scheduler`  |
| `insightScheduler.version`                   | Container image tag                             | `3.1.2`                               |
| `insightScheduler.service.type`              | Insight Scheduler service type                  | `ClusterIP`                           |
| `insightScheduler.externalPort`              | Insight Scheduler service external port         | `8080`                                |
| `insightScheduler.internalPort`              | Insight Scheduler service internal port         | `8080`                                |
| `insightExecutor.name`                       | Insight Executor name                           | `insight-scheduler`                   |
| `insightExecutor.replicaCount`               | Insight Executor replica count                  | `1`                                   |
| `insightExecutor.image`                      | Container image                                 | `docker.jfrog.io/jfrog/insight-executor`   |
| `insightExecutor.version`                    | Container image tag                             | `3.1.2`                               |
| `insightExecutor.service.type`               | Insight Executor service type                   | `ClusterIP`                           |
| `insightExecutor.externalPort`               | Insight Executor service external port          | `8080`                                |
| `insightExecutor.internalPort`               | Insight Executor service internal port          | `8080`                                |
| `insightExecutor.persistence.mountPath`      | Insight Executor persistence volume mount path  | `"/var/cloudbox"`                     |
| `insightExecutor.persistence.enabled`        | Insight Executor persistence volume enabled     | `true`                                |
| `insightExecutor.persistence.storageClass`   | Storage class of backing PVC                    | `nil (uses alpha storage class annotation)`|
| `insightExecutor.persistence.existingClaim`  | Provide an existing PersistentVolumeClaim       | `nil`                                 |
| `insightExecutor.persistence.accessMode`     | Insight Executor persistence volume access mode | `ReadWriteOnce`                       |
| `insightExecutor.persistence.size`           | Insight Executor persistence volume size        | `100Gi`                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.


## Useful links
- https://www.jfrog.com
- https://www.jfrog.com/confluence/
- https://www.jfrog.com/confluence/display/EP/Getting+Started