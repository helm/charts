#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# export JAVA_HOME=
# export MASTER=spark://spark-master:7077                 		# Spark master url. eg. spark://master_addr:7077. Leave empty if you want to use local mode.
export MASTER="${SPARK_MASTER:=local[*]}"
# export ZEPPELIN_JAVA_OPTS      		# Additional jvm options. for example, export ZEPPELIN_JAVA_OPTS="-Dspark.executor.memory=8g -Dspark.cores.max=16"
# export ZEPPELIN_MEM            		# Zeppelin jvm mem options Default -Xms1024m -Xmx1024m -XX:MaxPermSize=512m
# export ZEPPELIN_INTP_MEM       		# zeppelin interpreter process jvm mem options. Default -Xms1024m -Xmx1024m -XX:MaxPermSize=512m
# export ZEPPELIN_INTP_JAVA_OPTS 		# zeppelin interpreter process jvm options.
# export ZEPPELIN_SSL_PORT       		# ssl port (used when ssl environment variable is set to true)
# export ZEPPELIN_JMX_ENABLE    		# Enable JMX feature by defining "true"
# export ZEPPELIN_JMX_PORT      		# Port number which JMX uses. Default: "9996"

# export ZEPPELIN_LOG_DIR        		# Where log files are stored.  PWD by default.
# export ZEPPELIN_PID_DIR        		# The pid files are stored. ${ZEPPELIN_HOME}/run by default.
# export ZEPPELIN_WAR_TEMPDIR    		# The location of jetty temporary directory.
# export ZEPPELIN_NOTEBOOK_DIR   		# Where notebook saved
# export ZEPPELIN_NOTEBOOK_HOMESCREEN		# Id of notebook to be displayed in homescreen. ex) 2A94M5J1Z
# export ZEPPELIN_NOTEBOOK_HOMESCREEN_HIDE	# hide homescreen notebook from list when this value set to "true". default "false"

# export ZEPPELIN_NOTEBOOK_S3_BUCKET        # Bucket where notebook saved
# export ZEPPELIN_NOTEBOOK_S3_ENDPOINT      # Endpoint of the bucket
# export ZEPPELIN_NOTEBOOK_S3_USER          # User in bucket where notebook saved. For example bucket/user/notebook/2A94M5J1Z/note.json
# export ZEPPELIN_NOTEBOOK_S3_KMS_KEY_ID    # AWS KMS key ID
# export ZEPPELIN_NOTEBOOK_S3_KMS_KEY_REGION      # AWS KMS key region
# export ZEPPELIN_NOTEBOOK_S3_SSE      # Server-side encryption enabled for notebooks

# export ZEPPELIN_NOTEBOOK_GCS_STORAGE_DIR      # GCS "directory" (prefix) under which notebooks are saved. E.g. gs://example-bucket/path/to/dir
# export GOOGLE_APPLICATION_CREDENTIALS         # Provide a service account key file for GCS and BigQuery API calls (overrides application default credentials)

# export ZEPPELIN_NOTEBOOK_MONGO_URI				# MongoDB connection URI used to connect to a MongoDB database server. Default "mongodb://localhost"
# export ZEPPELIN_NOTEBOOK_MONGO_DATABASE		# Database name to store notebook. Default "zeppelin"
# export ZEPPELIN_NOTEBOOK_MONGO_COLLECTION # Collection name to store notebook. Default "notes"
# export ZEPPELIN_NOTEBOOK_MONGO_AUTOIMPORT	# If "true" import local notes under ZEPPELIN_NOTEBOOK_DIR on startup. Default "false"

# export ZEPPELIN_IDENT_STRING   		# A string representing this instance of zeppelin. $USER by default.
# export ZEPPELIN_NICENESS       		# The scheduling priority for daemons. Defaults to 0.
# export ZEPPELIN_INTERPRETER_LOCALREPO         # Local repository for interpreter's additional dependency loading
# export ZEPPELIN_INTERPRETER_DEP_MVNREPO       # Remote principal repository for interpreter's additional dependency loading
# export ZEPPELIN_HELIUM_NODE_INSTALLER_URL     # Remote Node installer url for Helium dependency loader
# export ZEPPELIN_HELIUM_NPM_INSTALLER_URL      # Remote Npm installer url for Helium dependency loader
# export ZEPPELIN_HELIUM_YARNPKG_INSTALLER_URL  # Remote Yarn package installer url for Helium dependency loader
# export ZEPPELIN_NOTEBOOK_STORAGE 		# Refers to pluggable notebook storage class, can have two classes simultaneously with a sync between them (e.g. local and remote).
# export ZEPPELIN_NOTEBOOK_ONE_WAY_SYNC	# If there are multiple notebook storages, should we treat the first one as the only source of truth?
# export ZEPPELIN_NOTEBOOK_PUBLIC   # Make notebook public by default when created, private otherwise

#### Spark interpreter configuration ####

## Kerberos ticket refresh setting
##
#export KINIT_FAIL_THRESHOLD                    # (optional) How many times should kinit retry. The default value is 5.
#export KERBEROS_REFRESH_INTERVAL               # (optional) The refresh interval for Kerberos ticket. The default value is 1d.

## Use provided spark installation ##
## defining SPARK_HOME makes Zeppelin run spark interpreter process using spark-submit
##
export SPARK_HOME=/opt/spark/                            # (required) When it is defined, load it instead of Zeppelin embedded Spark libraries
# export SPARK_SUBMIT_OPTIONS="--packages com.microsoft.ml.spark:mmlspark_2.11:0.14.dev42 --repositories https://mmlspark.azureedge.net/maven"                 # (optional) extra options to pass to spark submit. eg) "--driver-memory 512M --executor-memory 1G".
# export SPARK_APP_NAME                         # (optional) The name of spark application.

## Use embedded spark binaries ##
## without SPARK_HOME defined, Zeppelin still able to run spark interpreter process using embedded spark binaries.
## however, it is not encouraged when you can define SPARK_HOME
##
# Options read in YARN client mode
# export HADOOP_CONF_DIR         		# yarn-site.xml is located in configuration directory in HADOOP_CONF_DIR.
# Pyspark (supported with Spark 1.2.1 and above)
# To configure pyspark, you need to set spark distribution's path to 'spark.home' property in Interpreter setting screen in Zeppelin GUI
# export PYSPARK_PYTHON          		# path to the python command. must be the same path on the driver(Zeppelin) and all workers.
# export PYTHONPATH

## Spark interpreter options ##
##
# export ZEPPELIN_SPARK_USEHIVECONTEXT  # Use HiveContext instead of SQLContext if set true. true by default.
# export ZEPPELIN_SPARK_CONCURRENTSQL   # Execute multiple SQL concurrently if set true. false by default.
# export ZEPPELIN_SPARK_IMPORTIMPLICIT  # Import implicits, UDF collection, and sql if set true. true by default.
# export ZEPPELIN_SPARK_MAXRESULT       # Max number of Spark SQL result to display. 1000 by default.
# export ZEPPELIN_WEBSOCKET_MAX_TEXT_MESSAGE_SIZE       # Size in characters of the maximum text message to be received by websocket. Defaults to 1024000


#### HBase interpreter configuration ####

## To connect to HBase running on a cluster, either HBASE_HOME or HBASE_CONF_DIR must be set

# export HBASE_HOME=                    # (require) Under which HBase scripts and configuration should be
# export HBASE_CONF_DIR=                # (optional) Alternatively, configuration directory can be set to point to the directory that has hbase-site.xml

#### ZeppelinHub connection configuration ####
# export ZEPPELINHUB_API_ADDRESS		# Refers to the address of the ZeppelinHub service in use
# export ZEPPELINHUB_API_TOKEN			# Refers to the Zeppelin instance token of the user
# export ZEPPELINHUB_USER_KEY			# Optional, when using Zeppelin with authentication.

#### Zeppelin impersonation configuration
# export ZEPPELIN_IMPERSONATE_CMD       # Optional, when user want to run interpreter as end web user. eg) 'sudo -H -u ${ZEPPELIN_IMPERSONATE_USER} bash -c '
# export ZEPPELIN_IMPERSONATE_SPARK_PROXY_USER  #Optional, by default is true; can be set to false if you don't want to use --proxy-user option with Spark interpreter when impersonation enabled
