[DEFAULT]

#
# From ironic
#

# Authentication strategy used by ironic-api. "noauth" should
# not be used in a production environment because all
# authentication will be disabled. (string value)
# Possible values:
# noauth - no authentication
# keystone - use the Identity service for authentication
auth_strategy = noauth

# Return server tracebacks in the API response for any error
# responses. WARNING: this is insecure and should not be used
# in a production environment. (boolean value)
#debug_tracebacks_in_api = false

# Enable pecan debug mode. WARNING: this is insecure and
# should not be used in a production environment. (boolean
# value)
#pecan_debug = false

# Resource class to use for new nodes when no resource class
# is provided in the creation request. (string value)
#default_resource_class = <None>

# DEPRECATED: This option is left for a start up check only.
# Any non-empty value will prevent the conductor from
# starting. (list value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Hardware types should be used instead of classic
# drivers. They are enabled via the enabled_hardware_types
# option.
#enabled_drivers =

# Specify the list of hardware types to load during service
# initialization. Missing hardware types, or hardware types
# which fail to initialize, will prevent the conductor service
# from starting. This option defaults to a recommended set of
# production-oriented hardware types. A complete list of
# hardware types present on your system may be found by
# enumerating the "ironic.hardware.types" entrypoint. (list
# value)
enabled_hardware_types =  {{ .Values.config.default.enabled_hardware_types | default "ipmi" }}

# Specify the list of bios interfaces to load during service
# initialization. Missing bios interfaces, or bios interfaces
# which fail to initialize, will prevent the ironic-conductor
# service from starting. At least one bios interface that is
# supported by each enabled hardware type must be enabled
# here, or the ironic-conductor service will not start. Must
# not be an empty list. The default value is a recommended set
# of production-oriented bios interfaces. A complete list of
# bios interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.bios"
# entrypoint. When setting this value, please make sure that
# every enabled hardware type will have the same set of
# enabled bios interfaces on every ironic-conductor service.
# (list value)
#enabled_bios_interfaces = no-bios

# Default bios interface to be used for nodes that do not have
# bios_interface field set. A complete list of bios interfaces
# present on your system may be found by enumerating the
# "ironic.hardware.interfaces.bios" entrypoint. (string value)
#default_bios_interface = <None>

# Specify the list of boot interfaces to load during service
# initialization. Missing boot interfaces, or boot interfaces
# which fail to initialize, will prevent the ironic-conductor
# service from starting. At least one boot interface that is
# supported by each enabled hardware type must be enabled
# here, or the ironic-conductor service will not start. Must
# not be an empty list. The default value is a recommended set
# of production-oriented boot interfaces. A complete list of
# boot interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.boot"
# entrypoint. When setting this value, please make sure that
# every enabled hardware type will have the same set of
# enabled boot interfaces on every ironic-conductor service.
# (list value)
#enabled_boot_interfaces = pxe

# Default boot interface to be used for nodes that do not have
# boot_interface field set. A complete list of boot interfaces
# present on your system may be found by enumerating the
# "ironic.hardware.interfaces.boot" entrypoint. (string value)
#default_boot_interface = <None>

# Specify the list of console interfaces to load during
# service initialization. Missing console interfaces, or
# console interfaces which fail to initialize, will prevent
# the ironic-conductor service from starting. At least one
# console interface that is supported by each enabled hardware
# type must be enabled here, or the ironic-conductor service
# will not start. Must not be an empty list. The default value
# is a recommended set of production-oriented console
# interfaces. A complete list of console interfaces present on
# your system may be found by enumerating the
# "ironic.hardware.interfaces.console" entrypoint. When
# setting this value, please make sure that every enabled
# hardware type will have the same set of enabled console
# interfaces on every ironic-conductor service. (list value)
#enabled_console_interfaces = no-console

# Default console interface to be used for nodes that do not
# have console_interface field set. A complete list of console
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.console"
# entrypoint. (string value)
#default_console_interface = <None>

# Specify the list of deploy interfaces to load during service
# initialization. Missing deploy interfaces, or deploy
# interfaces which fail to initialize, will prevent the
# ironic-conductor service from starting. At least one deploy
# interface that is supported by each enabled hardware type
# must be enabled here, or the ironic-conductor service will
# not start. Must not be an empty list. The default value is a
# recommended set of production-oriented deploy interfaces. A
# complete list of deploy interfaces present on your system
# may be found by enumerating the
# "ironic.hardware.interfaces.deploy" entrypoint. When setting
# this value, please make sure that every enabled hardware
# type will have the same set of enabled deploy interfaces on
# every ironic-conductor service. (list value)
#enabled_deploy_interfaces = iscsi,direct

# Default deploy interface to be used for nodes that do not
# have deploy_interface field set. A complete list of deploy
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.deploy"
# entrypoint. (string value)
#default_deploy_interface = <None>

# Specify the list of inspect interfaces to load during
# service initialization. Missing inspect interfaces, or
# inspect interfaces which fail to initialize, will prevent
# the ironic-conductor service from starting. At least one
# inspect interface that is supported by each enabled hardware
# type must be enabled here, or the ironic-conductor service
# will not start. Must not be an empty list. The default value
# is a recommended set of production-oriented inspect
# interfaces. A complete list of inspect interfaces present on
# your system may be found by enumerating the
# "ironic.hardware.interfaces.inspect" entrypoint. When
# setting this value, please make sure that every enabled
# hardware type will have the same set of enabled inspect
# interfaces on every ironic-conductor service. (list value)
#enabled_inspect_interfaces = no-inspect

# Default inspect interface to be used for nodes that do not
# have inspect_interface field set. A complete list of inspect
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.inspect"
# entrypoint. (string value)
#default_inspect_interface = <None>

# Specify the list of management interfaces to load during
# service initialization. Missing management interfaces, or
# management interfaces which fail to initialize, will prevent
# the ironic-conductor service from starting. At least one
# management interface that is supported by each enabled
# hardware type must be enabled here, or the ironic-conductor
# service will not start. Must not be an empty list. The
# default value is a recommended set of production-oriented
# management interfaces. A complete list of management
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.management"
# entrypoint. When setting this value, please make sure that
# every enabled hardware type will have the same set of
# enabled management interfaces on every ironic-conductor
# service. (list value)
#enabled_management_interfaces = ipmitool

# Default management interface to be used for nodes that do
# not have management_interface field set. A complete list of
# management interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.management"
# entrypoint. (string value)
#default_management_interface = <None>

# Specify the list of network interfaces to load during
# service initialization. Missing network interfaces, or
# network interfaces which fail to initialize, will prevent
# the ironic-conductor service from starting. At least one
# network interface that is supported by each enabled hardware
# type must be enabled here, or the ironic-conductor service
# will not start. Must not be an empty list. The default value
# is a recommended set of production-oriented network
# interfaces. A complete list of network interfaces present on
# your system may be found by enumerating the
# "ironic.hardware.interfaces.network" entrypoint. When
# setting this value, please make sure that every enabled
# hardware type will have the same set of enabled network
# interfaces on every ironic-conductor service. (list value)
enabled_network_interfaces = noop

# Default network interface to be used for nodes that do not
# have network_interface field set. A complete list of network
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.network"
# entrypoint. (string value)
#default_network_interface = <None>

# Specify the list of power interfaces to load during service
# initialization. Missing power interfaces, or power
# interfaces which fail to initialize, will prevent the
# ironic-conductor service from starting. At least one power
# interface that is supported by each enabled hardware type
# must be enabled here, or the ironic-conductor service will
# not start. Must not be an empty list. The default value is a
# recommended set of production-oriented power interfaces. A
# complete list of power interfaces present on your system may
# be found by enumerating the
# "ironic.hardware.interfaces.power" entrypoint. When setting
# this value, please make sure that every enabled hardware
# type will have the same set of enabled power interfaces on
# every ironic-conductor service. (list value)
#enabled_power_interfaces = ipmitool

# Default power interface to be used for nodes that do not
# have power_interface field set. A complete list of power
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.power"
# entrypoint. (string value)
#default_power_interface = <None>

# Specify the list of raid interfaces to load during service
# initialization. Missing raid interfaces, or raid interfaces
# which fail to initialize, will prevent the ironic-conductor
# service from starting. At least one raid interface that is
# supported by each enabled hardware type must be enabled
# here, or the ironic-conductor service will not start. Must
# not be an empty list. The default value is a recommended set
# of production-oriented raid interfaces. A complete list of
# raid interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.raid"
# entrypoint. When setting this value, please make sure that
# every enabled hardware type will have the same set of
# enabled raid interfaces on every ironic-conductor service.
# (list value)
#enabled_raid_interfaces = agent,no-raid

# Default raid interface to be used for nodes that do not have
# raid_interface field set. A complete list of raid interfaces
# present on your system may be found by enumerating the
# "ironic.hardware.interfaces.raid" entrypoint. (string value)
#default_raid_interface = <None>

# Specify the list of rescue interfaces to load during service
# initialization. Missing rescue interfaces, or rescue
# interfaces which fail to initialize, will prevent the
# ironic-conductor service from starting. At least one rescue
# interface that is supported by each enabled hardware type
# must be enabled here, or the ironic-conductor service will
# not start. Must not be an empty list. The default value is a
# recommended set of production-oriented rescue interfaces. A
# complete list of rescue interfaces present on your system
# may be found by enumerating the
# "ironic.hardware.interfaces.rescue" entrypoint. When setting
# this value, please make sure that every enabled hardware
# type will have the same set of enabled rescue interfaces on
# every ironic-conductor service. (list value)
#enabled_rescue_interfaces = no-rescue

# Default rescue interface to be used for nodes that do not
# have rescue_interface field set. A complete list of rescue
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.rescue"
# entrypoint. (string value)
#default_rescue_interface = <None>

# Specify the list of storage interfaces to load during
# service initialization. Missing storage interfaces, or
# storage interfaces which fail to initialize, will prevent
# the ironic-conductor service from starting. At least one
# storage interface that is supported by each enabled hardware
# type must be enabled here, or the ironic-conductor service
# will not start. Must not be an empty list. The default value
# is a recommended set of production-oriented storage
# interfaces. A complete list of storage interfaces present on
# your system may be found by enumerating the
# "ironic.hardware.interfaces.storage" entrypoint. When
# setting this value, please make sure that every enabled
# hardware type will have the same set of enabled storage
# interfaces on every ironic-conductor service. (list value)
#enabled_storage_interfaces = cinder,noop

# Default storage interface to be used for nodes that do not
# have storage_interface field set. A complete list of storage
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.storage"
# entrypoint. (string value)
#default_storage_interface = <None>

# Specify the list of vendor interfaces to load during service
# initialization. Missing vendor interfaces, or vendor
# interfaces which fail to initialize, will prevent the
# ironic-conductor service from starting. At least one vendor
# interface that is supported by each enabled hardware type
# must be enabled here, or the ironic-conductor service will
# not start. Must not be an empty list. The default value is a
# recommended set of production-oriented vendor interfaces. A
# complete list of vendor interfaces present on your system
# may be found by enumerating the
# "ironic.hardware.interfaces.vendor" entrypoint. When setting
# this value, please make sure that every enabled hardware
# type will have the same set of enabled vendor interfaces on
# every ironic-conductor service. (list value)
#enabled_vendor_interfaces = ipmitool,no-vendor

# Default vendor interface to be used for nodes that do not
# have vendor_interface field set. A complete list of vendor
# interfaces present on your system may be found by
# enumerating the "ironic.hardware.interfaces.vendor"
# entrypoint. (string value)
#default_vendor_interface = <None>

# Used if there is a formatting error when generating an
# exception message (a programming error). If True, raise an
# exception; if False, use the unformatted message. (boolean
# value)
#fatal_exception_format_errors = false

# Exponent to determine number of hash partitions to use when
# distributing load across conductors. Larger values will
# result in more even distribution of load and less load when
# rebalancing the ring, but more memory usage. Number of
# partitions per conductor is (2^hash_partition_exponent).
# This determines the granularity of rebalancing: given 10
# hosts, and an exponent of the 2, there are 40 partitions in
# the ring.A few thousand partitions should make rebalancing
# smooth in most cases. The default is suitable for up to a
# few hundred conductors. Configuring for too many partitions
# has a negative impact on CPU usage. (integer value)
#hash_partition_exponent = 5

# [Experimental Feature] Number of hosts to map onto each hash
# partition. Setting this to more than one will cause
# additional conductor services to prepare deployment
# environments and potentially allow the Ironic cluster to
# recover more quickly if a conductor instance is terminated.
# (integer value)
#hash_distribution_replicas = 1

# Interval (in seconds) between hash ring resets. (integer
# value)
#hash_ring_reset_interval = 180

# If True, convert backing images to "raw" disk image format.
# (boolean value)
#force_raw_images = true

# Path to isolinux binary file. (string value)
#isolinux_bin = /usr/lib/syslinux/isolinux.bin

# Template file for isolinux configuration file. (string
# value)
#isolinux_config_template = $pybasedir/common/isolinux_config.template

# Template file for grub configuration file. (string value)
#grub_config_template = $pybasedir/common/grub_conf.template

# Path to ldlinux.c32 file. This file is required for syslinux
# 5.0 or later. If not specified, the file is looked for in
# "/usr/lib/syslinux/modules/bios/ldlinux.c32" and
# "/usr/share/syslinux/ldlinux.c32". (string value)
#ldlinux_c32 = <None>

# Run image downloads and raw format conversions in parallel.
# (boolean value)
#parallel_image_downloads = false

# IP address of this host. If unset, will determine the IP
# programmatically. If unable to do so, will use "127.0.0.1".
# (string value)
#my_ip = 127.0.0.1

# Specifies the minimum level for which to send notifications.
# If not set, no notifications will be sent. The default is
# for this option to be unset. (string value)
# Possible values:
# debug - "debug" level
# info - "info" level
# warning - "warning" level
# error - "error" level
# critical - "critical" level
#notification_level = <None>

# Directory where the ironic python module is installed.
# (string value)
#pybasedir = /usr/lib/python/site-packages/ironic/ironic

# Directory where ironic binaries are installed. (string
# value)
#bindir = $pybasedir/bin

# Top-level directory for maintaining ironic's state. (string
# value)
#state_path = $pybasedir

# Default mode for portgroups. Allowed values can be found in
# the linux kernel documentation on bonding:
# https://www.kernel.org/doc/Documentation/networking/bonding.txt.
# (string value)
#default_portgroup_mode = active-backup

# Name of this node. This can be an opaque identifier. It is
# not necessarily a hostname, FQDN, or IP address. However,
# the node name must be valid within an AMQP key, and if using
# ZeroMQ (will be removed in the Stein release), a valid
# hostname, FQDN, or IP address. (string value)
#host = localhost

# Used for rolling upgrades. Setting this option downgrades
# (or pins) the Bare Metal API, the internal ironic RPC
# communication, and the database objects to their respective
# versions, so they are compatible with older services. When
# doing a rolling upgrade from version N to version N+1, set
# (to pin) this to N. To unpin (default), leave it unset and
# the latest versions will be used. (string value)
# Possible values:
# rocky - "rocky" release
# queens - "queens" release
# 9.2 - "9.2" release
# 11.1 - "11.1" release
# 11.0 - "11.0" release
# 10.1 - "10.1" release
# 10.0 - "10.0" release
# Note: This option can be changed without restarting.
#pin_release_version = <None>

# Path to the rootwrap configuration file to use for running
# commands as root. (string value)
#rootwrap_config = /etc/ironic/rootwrap.conf

# Temporary working directory, default is Python temp dir.
# (string value)
#tempdir = /tmp

#
# From oslo.log
#

# If set to true, the logging level will be set to DEBUG
# instead of the default INFO level. (boolean value)
# Note: This option can be changed without restarting.
debug = {{ .Values.config.default.debug | default false }}

# The name of a logging configuration file. This file is
# appended to any existing logging configuration files. For
# details about logging configuration files, see the Python
# logging module documentation. Note that when logging
# configuration files are used then all logging configuration
# is set in the configuration file and other logging
# configuration options are ignored (for example,
# logging_context_format_string). (string value)
# Note: This option can be changed without restarting.
# Deprecated group/name - [DEFAULT]/log_config
#log_config_append = <None>

# Defines the format string for %%(asctime)s in log records.
# Default: %(default)s . This option is ignored if
# log_config_append is set. (string value)
#log_date_format = %Y-%m-%d %H:%M:%S

# (Optional) Name of log file to send logging output to. If no
# default is set, logging will go to stderr as defined by
# use_stderr. This option is ignored if log_config_append is
# set. (string value)
# Deprecated group/name - [DEFAULT]/logfile
#log_file = <None>

# (Optional) The base directory used for relative log_file
# paths. This option is ignored if log_config_append is set.
# (string value)
# Deprecated group/name - [DEFAULT]/logdir
#log_dir = <None>

# Uses logging handler designed to watch file system. When log
# file is moved or removed this handler will open a new log
# file with specified path instantaneously. It makes sense
# only if log_file option is specified and Linux platform is
# used. This option is ignored if log_config_append is set.
# (boolean value)
#watch_log_file = false

# Use syslog for logging. Existing syslog format is DEPRECATED
# and will be changed later to honor RFC5424. This option is
# ignored if log_config_append is set. (boolean value)
#use_syslog = false

# Enable journald for logging. If running in a systemd
# environment you may wish to enable journal support. Doing so
# will use the journal native protocol which includes
# structured metadata in addition to log messages.This option
# is ignored if log_config_append is set. (boolean value)
#use_journal = false

# Syslog facility to receive log lines. This option is ignored
# if log_config_append is set. (string value)
#syslog_log_facility = LOG_USER

# Use JSON formatting for logging. This option is ignored if
# log_config_append is set. (boolean value)
#use_json = false

# Log output to standard error. This option is ignored if
# log_config_append is set. (boolean value)
#use_stderr = false

# Format string to use for log messages with context. (string
# value)
#logging_context_format_string = %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s

# Format string to use for log messages when context is
# undefined. (string value)
#logging_default_format_string = %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s

# Additional data to append to log message when logging level
# for the message is DEBUG. (string value)
#logging_debug_format_suffix = %(funcName)s %(pathname)s:%(lineno)d

# Prefix each line of exception output with this format.
# (string value)
#logging_exception_prefix = %(asctime)s.%(msecs)03d %(process)d ERROR %(name)s %(instance)s

# Defines the format string for %(user_identity)s that is used
# in logging_context_format_string. (string value)
#logging_user_identity_format = %(user)s %(tenant)s %(domain)s %(user_domain)s %(project_domain)s

# List of package logging levels in logger=LEVEL pairs. This
# option is ignored if log_config_append is set. (list value)
#default_log_levels = amqp=WARNING,amqplib=WARNING,qpid.messaging=INFO,oslo_messaging=INFO,oslo.messaging=INFO,sqlalchemy=WARNING,stevedore=INFO,eventlet.wsgi.server=INFO,iso8601=WARNING,requests=WARNING,neutronclient=WARNING,glanceclient=WARNING,urllib3.connectionpool=WARNING,keystonemiddleware.auth_token=INFO,keystoneauth.session=INFO

# Enables or disables publication of error events. (boolean
# value)
#publish_errors = false

# The format for an instance that is passed with the log
# message. (string value)
#instance_format = "[instance: %(uuid)s] "

# The format for an instance UUID that is passed with the log
# message. (string value)
#instance_uuid_format = "[instance: %(uuid)s] "

# Interval, number of seconds, of log rate limiting. (integer
# value)
#rate_limit_interval = 0

# Maximum number of logged messages per rate_limit_interval.
# (integer value)
#rate_limit_burst = 0

# Log level name used by rate limiting: CRITICAL, ERROR, INFO,
# WARNING, DEBUG or empty string. Logs with level greater or
# equal to rate_limit_except_level are not filtered. An empty
# string means that all levels are filtered. (string value)
#rate_limit_except_level = CRITICAL

# Enables or disables fatal status of deprecations. (boolean
# value)
#fatal_deprecations = false

#
# From oslo.messaging
#

# Size of RPC connection pool. (integer value)
#rpc_conn_pool_size = 30

# The pool size limit for connections expiration policy
# (integer value)
#conn_pool_min_size = 2

# The time-to-live in sec of idle connections in the pool
# (integer value)
#conn_pool_ttl = 1200

# ZeroMQ bind address. Should be a wildcard (*), an ethernet
# interface, or IP. The "host" option should point or resolve
# to this address. (string value)
#rpc_zmq_bind_address = *

# MatchMaker driver. (string value)
# Possible values:
# redis - <No description provided>
# sentinel - <No description provided>
# dummy - <No description provided>
#rpc_zmq_matchmaker = redis

# Number of ZeroMQ contexts, defaults to 1. (integer value)
#rpc_zmq_contexts = 1

# Maximum number of ingress messages to locally buffer per
# topic. Default is unlimited. (integer value)
#rpc_zmq_topic_backlog = <None>

# Directory for holding IPC sockets. (string value)
#rpc_zmq_ipc_dir = /var/run/openstack

# Name of this node. Must be a valid hostname, FQDN, or IP
# address. Must match "host" option, if running Nova. (string
# value)
#rpc_zmq_host = localhost

# Number of seconds to wait before all pending messages will
# be sent after closing a socket. The default value of -1
# specifies an infinite linger period. The value of 0
# specifies no linger period. Pending messages shall be
# discarded immediately when the socket is closed. Positive
# values specify an upper bound for the linger period.
# (integer value)
# Deprecated group/name - [DEFAULT]/rpc_cast_timeout
#zmq_linger = -1

# The default number of seconds that poll should wait. Poll
# raises timeout exception when timeout expired. (integer
# value)
#rpc_poll_timeout = 1

# Expiration timeout in seconds of a name service record about
# existing target ( < 0 means no timeout). (integer value)
#zmq_target_expire = 300

# Update period in seconds of a name service record about
# existing target. (integer value)
#zmq_target_update = 180

# Use PUB/SUB pattern for fanout methods. PUB/SUB always uses
# proxy. (boolean value)
#use_pub_sub = false

# Use ROUTER remote proxy. (boolean value)
#use_router_proxy = false

# This option makes direct connections dynamic or static. It
# makes sense only with use_router_proxy=False which means to
# use direct connections for direct message types (ignored
# otherwise). (boolean value)
#use_dynamic_connections = false

# How many additional connections to a host will be made for
# failover reasons. This option is actual only in dynamic
# connections mode. (integer value)
#zmq_failover_connections = 2

# Minimal port number for random ports range. (port value)
# Minimum value: 0
# Maximum value: 65535
#rpc_zmq_min_port = 49153

# Maximal port number for random ports range. (integer value)
# Minimum value: 1
# Maximum value: 65536
#rpc_zmq_max_port = 65536

# Number of retries to find free port number before fail with
# ZMQBindError. (integer value)
#rpc_zmq_bind_port_retries = 100

# Default serialization mechanism for
# serializing/deserializing outgoing/incoming messages (string
# value)
# Possible values:
# json - <No description provided>
# msgpack - <No description provided>
#rpc_zmq_serialization = json

# This option configures round-robin mode in zmq socket. True
# means not keeping a queue when server side disconnects.
# False means to keep queue and messages even if server is
# disconnected, when the server appears we send all
# accumulated messages to it. (boolean value)
#zmq_immediate = true

# Enable/disable TCP keepalive (KA) mechanism. The default
# value of -1 (or any other negative value) means to skip any
# overrides and leave it to OS default; 0 and 1 (or any other
# positive value) mean to disable and enable the option
# respectively. (integer value)
#zmq_tcp_keepalive = -1

# The duration between two keepalive transmissions in idle
# condition. The unit is platform dependent, for example,
# seconds in Linux, milliseconds in Windows etc. The default
# value of -1 (or any other negative value and 0) means to
# skip any overrides and leave it to OS default. (integer
# value)
#zmq_tcp_keepalive_idle = -1

# The number of retransmissions to be carried out before
# declaring that remote end is not available. The default
# value of -1 (or any other negative value and 0) means to
# skip any overrides and leave it to OS default. (integer
# value)
#zmq_tcp_keepalive_cnt = -1

# The duration between two successive keepalive
# retransmissions, if acknowledgement to the previous
# keepalive transmission is not received. The unit is platform
# dependent, for example, seconds in Linux, milliseconds in
# Windows etc. The default value of -1 (or any other negative
# value and 0) means to skip any overrides and leave it to OS
# default. (integer value)
#zmq_tcp_keepalive_intvl = -1

# Maximum number of (green) threads to work concurrently.
# (integer value)
#rpc_thread_pool_size = 100

# Expiration timeout in seconds of a sent/received message
# after which it is not tracked anymore by a client/server.
# (integer value)
#rpc_message_ttl = 300

# Wait for message acknowledgements from receivers. This
# mechanism works only via proxy without PUB/SUB. (boolean
# value)
#rpc_use_acks = false

# Number of seconds to wait for an ack from a cast/call. After
# each retry attempt this timeout is multiplied by some
# specified multiplier. (integer value)
#rpc_ack_timeout_base = 15

# Number to multiply base ack timeout by after each retry
# attempt. (integer value)
#rpc_ack_timeout_multiplier = 2

# Default number of message sending attempts in case of any
# problems occurred: positive value N means at most N retries,
# 0 means no retries, None or -1 (or any other negative
# values) mean to retry forever. This option is used only if
# acknowledgments are enabled. (integer value)
#rpc_retry_attempts = 3

# List of publisher hosts SubConsumer can subscribe on. This
# option has higher priority then the default publishers list
# taken from the matchmaker. (list value)
#subscribe_on =

# Size of executor thread pool when executor is threading or
# eventlet. (integer value)
# Deprecated group/name - [DEFAULT]/rpc_thread_pool_size
#executor_thread_pool_size = 64

# Seconds to wait for a response from a call. (integer value)
#rpc_response_timeout = 60

# The network address and optional user credentials for
# connecting to the messaging backend, in URL format. The
# expected format is:
#
# driver://[user:pass@]host:port[,[userN:passN@]hostN:portN]/virtual_host?query
#
# Example: rabbit://rabbitmq:password@127.0.0.1:5672//
#
# For full details on the fields in the URL see the
# documentation of oslo_messaging.TransportURL at
# https://docs.openstack.org/oslo.messaging/latest/reference/transport.html
# (string value)
transport_url = rabbit://{{ .Values.rabbitmq.rabbitmq.username }}:{{ .Values.rabbitmq.rabbitmq.password }}@{{ .Release.Name }}-rabbitmq:5672

# DEPRECATED: The messaging driver to use, defaults to rabbit.
# Other drivers include amqp and zmq. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#rpc_backend = rabbit

# The default exchange under which topics are scoped. May be
# overridden by an exchange name specified in the
# transport_url option. (string value)
#control_exchange = openstack

#
# From oslo.service.periodic_task
#

# Some periodic tasks can be run in a separate process. Should
# we run them here? (boolean value)
#run_external_periodic_tasks = true

#
# From oslo.service.service
#

# Enable eventlet backdoor.  Acceptable values are 0, <port>,
# and <start>:<end>, where 0 results in listening on a random
# tcp port number; <port> results in listening on the
# specified port number (and not enabling backdoor if that
# port is in use); and <start>:<end> results in listening on
# the smallest unused port number within the specified range
# of port numbers.  The chosen port is displayed in the
# service's log file. (string value)
#backdoor_port = <None>

# Enable eventlet backdoor, using the provided path as a unix
# socket that can receive connections. This option is mutually
# exclusive with 'backdoor_port' in that only one should be
# provided. If both are provided then the existence of this
# option overrides the usage of that option. (string value)
#backdoor_socket = <None>

# Enables or disables logging values of all registered options
# when starting a service (at DEBUG level). (boolean value)
#log_options = true

# Specify a timeout after which a gracefully shutdown server
# will exit. Zero value means endless wait. (integer value)
#graceful_shutdown_timeout = 60


[agent]

#
# From ironic
#

# Whether Ironic will manage booting of the agent ramdisk. If
# set to False, you will need to configure your mechanism to
# allow booting the agent ramdisk. (boolean value)
#manage_agent_boot = true

# The memory size in MiB consumed by agent when it is booted
# on a bare metal node. This is used for checking if the image
# can be downloaded and deployed on the bare metal node after
# booting agent ramdisk. This may be set according to the
# memory consumed by the agent ramdisk image. (integer value)
#memory_consumed_by_agent = 0

# Whether the agent ramdisk should stream raw images directly
# onto the disk or not. By streaming raw images directly onto
# the disk the agent ramdisk will not spend time copying the
# image to a tmpfs partition (therefore consuming less memory)
# prior to writing it to the disk. Unless the disk where the
# image will be copied to is really slow, this option should
# be set to True. Defaults to True. (boolean value)
#stream_raw_images = true

# Number of times to retry getting power state to check if
# bare metal node has been powered off after a soft power off.
# (integer value)
#post_deploy_get_power_state_retries = 6

# Amount of time (in seconds) to wait between polling power
# state after trigger soft poweroff. (integer value)
#post_deploy_get_power_state_retry_interval = 5

# API version to use for communicating with the ramdisk agent.
# (string value)
#agent_api_version = v1

# Whether Ironic should collect the deployment logs on
# deployment failure (on_failure), always or never. (string
# value)
# Possible values:
# always - always collect the logs
# on_failure - only collect logs if there is a failure
# never - never collect logs
#deploy_logs_collect = on_failure

# The name of the storage backend where the logs will be
# stored. (string value)
# Possible values:
# local - store the logs locally
# swift - store the logs in Object Storage service
#deploy_logs_storage_backend = local

# The path to the directory where the logs should be stored,
# used when the deploy_logs_storage_backend is configured to
# "local". (string value)
#deploy_logs_local_path = /var/log/ironic/deploy

# The name of the Swift container to store the logs, used when
# the deploy_logs_storage_backend is configured to "swift".
# (string value)
#deploy_logs_swift_container = ironic_deploy_logs_container

# Number of days before a log object is marked as expired in
# Swift. If None, the logs will be kept forever or until
# manually deleted. Used when the deploy_logs_storage_backend
# is configured to "swift". (integer value)
#deploy_logs_swift_days_to_expire = 30


[ansible]

#
# From ironic
#

# Extra arguments to pass on every invocation of Ansible.
# (string value)
#ansible_extra_args = <None>

# Set ansible verbosity level requested when invoking
# "ansible-playbook" command. 4 includes detailed SSH session
# logging. Default is 4 when global debug is enabled and 0
# otherwise. (integer value)
# Minimum value: 0
# Maximum value: 4
#verbosity = <None>

# Path to "ansible-playbook" script. Default will search the
# $PATH configured for user running ironic-conductor process.
# Provide the full path when ansible-playbook is not in $PATH
# or installed in not default location. (string value)
#ansible_playbook_script = ansible-playbook

# Path to directory with playbooks, roles and local inventory.
# (string value)
#playbooks_path = $pybasedir/drivers/modules/ansible/playbooks

# Path to ansible configuration file. If set to empty, system
# default will be used. (string value)
#config_file_path = $pybasedir/drivers/modules/ansible/playbooks/ansible.cfg

# Number of times to retry getting power state to check if
# bare metal node has been powered off after a soft power off.
# Value of 0 means do not retry on failure. (integer value)
# Minimum value: 0
#post_deploy_get_power_state_retries = 6

# Amount of time (in seconds) to wait between polling power
# state after trigger soft poweroff. (integer value)
# Minimum value: 0
#post_deploy_get_power_state_retry_interval = 5

# Extra amount of memory in MiB expected to be consumed by
# Ansible-related processes on the node. Affects decision
# whether image will fit into RAM. (integer value)
#extra_memory = 10

# Skip verifying SSL connections to the image store when
# downloading the image. Setting it to "True" is only
# recommended for testing environments that use self-signed
# certificates. (boolean value)
#image_store_insecure = false

# Specific CA bundle to use for validating SSL connections to
# the image store. If not specified, CA available in the
# ramdisk will be used. Is not used by default playbooks
# included with the driver. Suitable for environments that use
# self-signed certificates. (string value)
#image_store_cafile = <None>

# Client cert to use for SSL connections to image store. Is
# not used by default playbooks included with the driver.
# (string value)
#image_store_certfile = <None>

# Client key to use for SSL connections to image store. Is not
# used by default playbooks included with the driver. (string
# value)
#image_store_keyfile = <None>

# Name of the user to use for Ansible when connecting to the
# ramdisk over SSH. It may be overridden by per-node
# 'ansible_username' option in node's 'driver_info' field.
# (string value)
#default_username = ansible

# Absolute path to the private SSH key file to use by Ansible
# by default when connecting to the ramdisk over SSH. Default
# is to use default SSH keys configured for the user running
# the ironic-conductor service. Private keys with password
# must be pre-loaded into 'ssh-agent'. It may be overridden by
# per-node 'ansible_key_file' option in node's 'driver_info'
# field. (string value)
#default_key_file = <None>

# Path (relative to $playbooks_path or absolute) to the
# default playbook used for deployment. It may be overridden
# by per-node 'ansible_deploy_playbook' option in node's
# 'driver_info' field. (string value)
#default_deploy_playbook = deploy.yaml

# Path (relative to $playbooks_path or absolute) to the
# default playbook used for graceful in-band shutdown of the
# node. It may be overridden by per-node
# 'ansible_shutdown_playbook' option in node's 'driver_info'
# field. (string value)
#default_shutdown_playbook = shutdown.yaml

# Path (relative to $playbooks_path or absolute) to the
# default playbook used for node cleaning. It may be
# overridden by per-node 'ansible_clean_playbook' option in
# node's 'driver_info' field. (string value)
#default_clean_playbook = clean.yaml

# Path (relative to $playbooks_path or absolute) to the
# default auxiliary cleaning steps file used during the node
# cleaning. It may be overridden by per-node
# 'ansible_clean_steps_config' option in node's 'driver_info'
# field. (string value)
#default_clean_steps_config = clean_steps.yaml


[api]

#
# From ironic
#

# The IP address on which ironic-api listens. (string value)
#host_ip = 0.0.0.0

# The TCP port on which ironic-api listens. (port value)
# Minimum value: 0
# Maximum value: 65535
port = {{ .Values.api.portInternal }}

# The maximum number of items returned in a single response
# from a collection resource. (integer value)
#max_limit = 1000

# Public URL to use when building the links to the API
# resources (for example, "https://ironic.rocks:6384"). If
# None the links will be built using the request's host URL.
# If the API is operating behind a proxy, you will want to
# change this to represent the proxy's URL. Defaults to None.
# (string value)
#public_endpoint = <None>

# Number of workers for OpenStack Ironic API service. The
# default is equal to the number of CPUs available if that can
# be determined, else a default worker count of 1 is returned.
# (integer value)
api_workers =  {{ .Values.config.api.api_workers | default "1" }}

# Enable the integrated stand-alone API to service requests
# via HTTPS instead of HTTP. If there is a front-end service
# performing HTTPS offloading from the service, this option
# should be False; note, you will want to change public API
# endpoint to represent SSL termination URL with
# 'public_endpoint' option. (boolean value)
#enable_ssl_api = false

# Whether to restrict the lookup API to only nodes in certain
# states. (boolean value)
#restrict_lookup = true

# Maximum interval (in seconds) for agent heartbeats. (integer
# value)
# Deprecated group/name - [agent]/heartbeat_timeout
#ramdisk_heartbeat_timeout = 300


[audit]

#
# From ironic
#

# Enable auditing of API requests (for ironic-api service).
# (boolean value)
#enabled = false

# Path to audit map file for ironic-api service. Used only
# when API audit is enabled. (string value)
#audit_map_file = /etc/ironic/api_audit_map.conf

# Comma separated list of Ironic REST API HTTP methods to be
# ignored during audit logging. For example: auditing will not
# be done on any GET or POST requests if this is set to
# "GET,POST". It is used only when API audit is enabled.
# (string value)
#ignore_req_list =


[cimc]

#
# From ironic
#

# Number of times a power operation needs to be retried
# (integer value)
#max_retry = 6

# Amount of time in seconds to wait in between power
# operations (integer value)
#action_interval = 10


[cinder]

#
# From ironic
#

# Number of retries in the case of a failed action (currently
# only used when detaching volumes). (integer value)
#action_retries = 3

# Retry interval in seconds in the case of a failed action
# (only specific actions are retried). (integer value)
#action_retry_interval = 5

# Authentication URL (string value)
#auth_url = <None>

# Authentication type to load (string value)
# Deprecated group/name - [cinder]/auth_plugin
#auth_type = <None>

# PEM encoded Certificate Authority to use when verifying
# HTTPs connections. (string value)
#cafile = <None>

# PEM encoded client certificate cert file (string value)
#certfile = <None>

# Collect per-API call timing information. (boolean value)
#collect_timing = false

# Optional domain ID to use with v3 and v2 parameters. It will
# be used for both the user and project domain in v3 and
# ignored in v2 authentication. (string value)
#default_domain_id = <None>

# Optional domain name to use with v3 API and v2 parameters.
# It will be used for both the user and project domain in v3
# and ignored in v2 authentication. (string value)
#default_domain_name = <None>

# Domain ID to scope to (string value)
#domain_id = <None>

# Domain name to scope to (string value)
#domain_name = <None>

# Always use this endpoint URL for requests for this client.
# NOTE: The unversioned endpoint should be specified here; to
# request a particular API version, use the `version`, `min-
# version`, and/or `max-version` options. (string value)
#endpoint_override = <None>

# Verify HTTPS connections. (boolean value)
#insecure = false

# PEM encoded client certificate key file (string value)
#keyfile = <None>

# The maximum major version of a given API, intended to be
# used as the upper bound of a range with min_version.
# Mutually exclusive with version. (string value)
#max_version = <None>

# The minimum major version of a given API, intended to be
# used as the lower bound of a range with max_version.
# Mutually exclusive with version. If min_version is given
# with no max_version it is as if max version is "latest".
# (string value)
#min_version = <None>

# User's password (string value)
#password = <None>

# Domain ID containing project (string value)
#project_domain_id = <None>

# Domain name containing project (string value)
#project_domain_name = <None>

# Project ID to scope to (string value)
# Deprecated group/name - [cinder]/tenant_id
#project_id = <None>

# Project name to scope to (string value)
# Deprecated group/name - [cinder]/tenant_name
#project_name = <None>

# The default region_name for endpoint URL discovery. (string
# value)
#region_name = <None>

# Client retries in the case of a failed request connection.
# (integer value)
#retries = 3

# The default service_name for endpoint URL discovery. (string
# value)
#service_name = <None>

# The default service_type for endpoint URL discovery. (string
# value)
#service_type = volumev3

# Log requests to multiple loggers. (boolean value)
#split_loggers = false

# Scope for system operations (string value)
#system_scope = <None>

# Tenant ID (string value)
#tenant_id = <None>

# Tenant Name (string value)
#tenant_name = <None>

# Timeout value for http requests (integer value)
#timeout = <None>

# Trust ID (string value)
#trust_id = <None>

# DEPRECATED: URL for connecting to cinder. If set, the value
# must start with either http:// or https://. (uri value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Use [cinder]/endpoint_override option to set a
# specific cinder API URL to connect to.
#url = <None>

# User's domain id (string value)
#user_domain_id = <None>

# User's domain name (string value)
#user_domain_name = <None>

# User id (string value)
#user_id = <None>

# Username (string value)
# Deprecated group/name - [cinder]/user_name
#username = <None>

# List of interfaces, in order of preference, for endpoint
# URL. (list value)
#valid_interfaces = internal,public

# Minimum Major API version within a given Major API version
# for endpoint URL discovery. Mutually exclusive with
# min_version and max_version (string value)
#version = <None>


[cisco_ucs]

#
# From ironic
#

# Number of times a power operation needs to be retried
# (integer value)
#max_retry = 6

# Amount of time in seconds to wait in between power
# operations (integer value)
#action_interval = 5


[conductor]

#
# From ironic
#

# The size of the workers greenthread pool. Note that 2
# threads will be reserved by the conductor itself for
# handling heart beats and periodic tasks. (integer value)
# Minimum value: 3
# workers_pool_size = 100

# Seconds between conductor heart beats. (integer value)
heartbeat_interval = {{ .Values.config.conductor.heartbeat_interval | default "10" }}

# DEPRECATED: URL of Ironic API service. If not set ironic can
# get the current value from the keystone service catalog. If
# set, the value must start with either http:// or https://.
# (uri value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Use [service_catalog]endpoint_override option
# instead if required to use a specific ironic api address,
# for example in noauth mode.
api_url = http://{{ .Values.api.externalIPs | first }}:{{ .Values.api.portExternal }}/

# Maximum time (in seconds) since the last check-in of a
# conductor. A conductor is considered inactive when this time
# has been exceeded. (integer value)
heartbeat_timeout = {{ .Values.config.conductor.heartbeat_timeout | default "30" }}

# Interval between syncing the node power state to the
# database, in seconds. (integer value)
#sync_power_state_interval = 60

# Interval between checks of provision timeouts, in seconds.
# (integer value)
#check_provision_state_interval = 60

# Interval (seconds) between checks of rescue timeouts.
# (integer value)
# Minimum value: 1
#check_rescue_state_interval = 60

# Timeout (seconds) to wait for a callback from a deploy
# ramdisk. Set to 0 to disable timeout. (integer value)
deploy_callback_timeout = {{ .Values.config.conductor.deploy_callback_timeout | default "1800" }}

# During sync_power_state, should the hardware power state be
# set to the state recorded in the database (True) or should
# the database be updated based on the hardware state (False).
# (boolean value)
#force_power_state_during_sync = true

# During sync_power_state failures, limit the number of times
# Ironic should try syncing the hardware node power state with
# the node power state in DB (integer value)
power_state_sync_max_retries = {{ .Values.config.conductor.power_state_sync_max_retries | default "3" }}

# Maximum number of worker threads that can be started
# simultaneously by a periodic task. Should be less than RPC
# thread pool size. (integer value)
#periodic_max_workers = 8

# Number of attempts to grab a node lock. (integer value)
#node_locked_retry_attempts = 3

# Seconds to sleep between node lock attempts. (integer value)
#node_locked_retry_interval = 1

# Enable sending sensor data message via the notification bus
# (boolean value)
#send_sensor_data = false

# Seconds between conductor sending sensor data message to
# ceilometer via the notification bus. (integer value)
#send_sensor_data_interval = 600

# The maximum number of workers that can be started
# simultaneously for send data from sensors periodic task.
# (integer value)
# Minimum value: 1
#send_sensor_data_workers = 4

# The time in seconds to wait for send sensors data periodic
# task to be finished before allowing periodic call to happen
# again. Should be less than send_sensor_data_interval value.
# (integer value)
#send_sensor_data_wait_timeout = 300

# List of comma separated meter types which need to be sent to
# Ceilometer. The default value, "ALL", is a special value
# meaning send all the sensor data. (list value)
#send_sensor_data_types = ALL

# When conductors join or leave the cluster, existing
# conductors may need to update any persistent local state as
# nodes are moved around the cluster. This option controls how
# often, in seconds, each conductor will check for nodes that
# it should "take over". Set it to a negative value to disable
# the check entirely. (integer value)
#sync_local_state_interval = 180

# Name of the Swift container to store config drive data. Used
# when configdrive_use_object_store is True. (string value)
#configdrive_swift_container = ironic_configdrive_container

# Timeout (seconds) for waiting for node inspection. 0 -
# unlimited. (integer value)
# Deprecated group/name - [conductor]/inspect_timeout
#inspect_wait_timeout = 1800

# Enables or disables automated cleaning. Automated cleaning
# is a configurable set of steps, such as erasing disk drives,
# that are performed on the node to ensure it is in a baseline
# state and ready to be deployed to. This is done after
# instance deletion as well as during the transition from a
# "manageable" to "available" state. When enabled, the
# particular steps performed to clean a node depend on which
# driver that node is managed by; see the individual driver's
# documentation for details. NOTE: The introduction of the
# cleaning operation causes instance deletion to take
# significantly longer. In an environment where all tenants
# are trusted (eg, because there is only one tenant), this
# option could be safely disabled. (boolean value)
automated_clean = {{ .Values.config.conductor.automated_clean | default true }}

# Timeout (seconds) to wait for a callback from the ramdisk
# doing the cleaning. If the timeout is reached the node will
# be put in the "clean failed" provision state. Set to 0 to
# disable timeout. (integer value)
clean_callback_timeout = {{ .Values.config.conductor.clean_callback_timeout | default "1800" }}

# Timeout (seconds) to wait for a callback from the rescue
# ramdisk. If the timeout is reached the node will be put in
# the "rescue failed" provision state. Set to 0 to disable
# timeout. (integer value)
# Minimum value: 0
#rescue_callback_timeout = 1800

# Timeout (in seconds) of soft reboot and soft power off
# operation. This value always has to be positive. (integer
# value)
# Minimum value: 1
#soft_power_off_timeout = 600

# Number of seconds to wait for power operations to complete,
# i.e., so that a baremetal node is in the desired power
# state. If timed out, the power operation is considered a
# failure. (integer value)
# Minimum value: 2
#power_state_change_timeout = 30

# Interval (in seconds) between checking the power state for
# nodes previously put into maintenance mode due to power
# synchronization failure. A node is automatically moved out
# of maintenance mode once its power state is retrieved
# successfully. Set to 0 to disable this check. (integer
# value)
# Minimum value: 0
#power_failure_recovery_interval = 300

# Name of the conductor group to join. Can be up to 255
# characters and is case insensitive. This conductor will only
# manage nodes with a matching "conductor_group" field set on
# the node. (string value)
#conductor_group =


[console]

#
# From ironic
#

# Path to serial console terminal program. Used only by Shell
# In A Box console. (string value)
#terminal = shellinaboxd

# Directory containing the terminal SSL cert (PEM) for serial
# console access. Used only by Shell In A Box console. (string
# value)
#terminal_cert_dir = <None>

# Directory for holding terminal pid files. If not specified,
# the temporary directory will be used. (string value)
#terminal_pid_dir = <None>

# Timeout (in seconds) for the terminal session to be closed
# on inactivity. Set to 0 to disable timeout. Used only by
# Socat console. (integer value)
# Minimum value: 0
#terminal_timeout = 600

# Time interval (in seconds) for checking the status of
# console subprocess. (integer value)
#subprocess_checking_interval = 1

# Time (in seconds) to wait for the console subprocess to
# start. (integer value)
#subprocess_timeout = 10

# IP address of Socat service running on the host of ironic
# conductor. Used only by Socat console. (IP address value)
#socat_address = $my_ip


[cors]

#
# From oslo.middleware.cors
#

# Indicate whether this resource may be shared with the domain
# received in the requests "origin" header. Format:
# "<protocol>://<host>[:<port>]", no trailing slash. Example:
# https://horizon.example.com (list value)
#allowed_origin = <None>

# Indicate that the actual request can include user
# credentials (boolean value)
#allow_credentials = true

# Indicate which headers are safe to expose to the API.
# Defaults to HTTP Simple Headers. (list value)
#expose_headers =

# Maximum cache age of CORS preflight requests. (integer
# value)
#max_age = 3600

# Indicate which methods can be used during the actual
# request. (list value)
#allow_methods = OPTIONS,GET,HEAD,POST,PUT,DELETE,TRACE,PATCH

# Indicate which header field names may be used during the
# actual request. (list value)
#allow_headers =


[database]

#
# From ironic
#

# MySQL engine to use. (string value)
#mysql_engine = InnoDB

#
# From oslo.db
#

# If True, SQLite uses synchronous mode. (boolean value)
#sqlite_synchronous = true

# The back end to use for the database. (string value)
# Deprecated group/name - [DEFAULT]/db_backend
#backend = sqlalchemy

# The SQLAlchemy connection string to use to connect to the
# database. (string value)
# Deprecated group/name - [DEFAULT]/sql_connection
# Deprecated group/name - [DATABASE]/sql_connection
# Deprecated group/name - [sql]/connection
connection = mysql+pymysql://{{ .Values.mysql.mysqlUser }}:{{ .Values.mysql.mysqlPassword }}@{{ .Release.Name }}-mysql/{{ .Values.mysql.mysqlDatabase }}?charset=utf8

# The SQLAlchemy connection string to use to connect to the
# slave database. (string value)
#slave_connection = <None>

# The SQL mode to be used for MySQL sessions. This option,
# including the default, overrides any server-set SQL mode. To
# use whatever SQL mode is set by the server configuration,
# set this to no value. Example: mysql_sql_mode= (string
# value)
#mysql_sql_mode = TRADITIONAL

# If True, transparently enables support for handling MySQL
# Cluster (NDB). (boolean value)
#mysql_enable_ndb = false

# Connections which have been present in the connection pool
# longer than this number of seconds will be replaced with a
# new one the next time they are checked out from the pool.
# (integer value)
# Deprecated group/name - [DATABASE]/idle_timeout
# Deprecated group/name - [database]/idle_timeout
# Deprecated group/name - [DEFAULT]/sql_idle_timeout
# Deprecated group/name - [DATABASE]/sql_idle_timeout
# Deprecated group/name - [sql]/idle_timeout
#connection_recycle_time = 3600

# DEPRECATED: Minimum number of SQL connections to keep open
# in a pool. (integer value)
# Deprecated group/name - [DEFAULT]/sql_min_pool_size
# Deprecated group/name - [DATABASE]/sql_min_pool_size
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: The option to set the minimum pool size is not
# supported by sqlalchemy.
#min_pool_size = 1

# Maximum number of SQL connections to keep open in a pool.
# Setting a value of 0 indicates no limit. (integer value)
# Deprecated group/name - [DEFAULT]/sql_max_pool_size
# Deprecated group/name - [DATABASE]/sql_max_pool_size
#max_pool_size = 5

# Maximum number of database connection retries during
# startup. Set to -1 to specify an infinite retry count.
# (integer value)
# Deprecated group/name - [DEFAULT]/sql_max_retries
# Deprecated group/name - [DATABASE]/sql_max_retries
#max_retries = 10

# Interval between retries of opening a SQL connection.
# (integer value)
# Deprecated group/name - [DEFAULT]/sql_retry_interval
# Deprecated group/name - [DATABASE]/reconnect_interval
#retry_interval = 10

# If set, use this value for max_overflow with SQLAlchemy.
# (integer value)
# Deprecated group/name - [DEFAULT]/sql_max_overflow
# Deprecated group/name - [DATABASE]/sqlalchemy_max_overflow
#max_overflow = 50

# Verbosity of SQL debugging information: 0=None,
# 100=Everything. (integer value)
# Minimum value: 0
# Maximum value: 100
# Deprecated group/name - [DEFAULT]/sql_connection_debug
#connection_debug = 0

# Add Python stack traces to SQL as comment strings. (boolean
# value)
# Deprecated group/name - [DEFAULT]/sql_connection_trace
#connection_trace = false

# If set, use this value for pool_timeout with SQLAlchemy.
# (integer value)
# Deprecated group/name - [DATABASE]/sqlalchemy_pool_timeout
#pool_timeout = <None>

# Enable the experimental use of database reconnect on
# connection lost. (boolean value)
#use_db_reconnect = false

# Seconds between retries of a database transaction. (integer
# value)
#db_retry_interval = 1

# If True, increases the interval between retries of a
# database operation up to db_max_retry_interval. (boolean
# value)
#db_inc_retry_interval = true

# If db_inc_retry_interval is set, the maximum seconds between
# retries of a database operation. (integer value)
#db_max_retry_interval = 10

# Maximum retries in case of connection error or deadlock
# error before error is raised. Set to -1 to specify an
# infinite retry count. (integer value)
#db_max_retries = 20

# Optional URL parameters to append onto the connection URL at
# connect time; specify as param1=value1&param2=value2&...
# (string value)
#connection_parameters =


[deploy]

#
# From ironic
#

# ironic-conductor node's HTTP server URL. Example:
# http://192.1.2.3:8080 (string value)
http_url = http://{{ .Values.httpboot.externalIPs | first }}/

# ironic-conductor node's HTTP root path. (string value)
http_root = /storage/httpboot

# Whether to support the use of ATA Secure Erase during the
# cleaning process. Defaults to True. (boolean value)
enable_ata_secure_erase = {{ .Values.config.deploy.enable_ata_secure_erase | default true }}

# Priority to run in-band erase devices via the Ironic Python
# Agent ramdisk. If unset, will use the priority set in the
# ramdisk (defaults to 10 for the GenericHardwareManager). If
# set to 0, will not run during cleaning. (integer value)
erase_devices_priority =  {{ .Values.config.deploy.erase_devices_priority }}

# Priority to run in-band clean step that erases metadata from
# devices, via the Ironic Python Agent ramdisk. If unset, will
# use the priority set in the ramdisk (defaults to 99 for the
# GenericHardwareManager). If set to 0, will not run during
# cleaning. (integer value)
erase_devices_metadata_priority = {{ .Values.config.deploy.erase_devices_metadata_priority }}

# During shred, overwrite all block devices N times with
# random data. This is only used if a device could not be ATA
# Secure Erased. Defaults to 1. (integer value)
# Minimum value: 0
#shred_random_overwrite_iterations = 1

# Whether to write zeros to a node's block devices after
# writing random data. This will write zeros to the device
# even when deploy.shred_random_overwrite_iterations is 0.
# This option is only used if a device could not be ATA Secure
# Erased. Defaults to True. (boolean value)
#shred_final_overwrite_with_zeros = true

# Defines what to do if an ATA secure erase operation fails
# during cleaning in the Ironic Python Agent. If False, the
# cleaning operation will fail and the node will be put in
# ``clean failed`` state. If True, shred will be invoked and
# cleaning will continue. (boolean value)
#continue_if_disk_secure_erase_fails = false

# Whether to power off a node after deploy failure. Defaults
# to True. (boolean value)
power_off_after_deploy_failure = {{ .Values.config.deploy.power_off_after_deploy_failure | default true }}

# Default boot option to use when no boot option is requested
# in node's driver_info. Currently the default is "netboot",
# but it will be changed to "local" in the future. It is
# recommended to set an explicit value for this option.
# (string value)
# Possible values:
# netboot - boot from a network
# local - local boot
#default_boot_option = <None>

# Default boot mode to use when no boot mode is requested in
# node's driver_info, capabilities or in the `instance_info`
# configuration. Currently the default boot mode is "bios".
# This option only has effect when management interface
# supports boot mode management (string value)
# Possible values:
# uefi - UEFI boot mode
# bios - Legacy BIOS boot mode
#default_boot_mode = bios

# Whether to upload the config drive to object store. Set this
# option to True to store config drive in a swift endpoint.
# (boolean value)
# Deprecated group/name - [conductor]/configdrive_use_swift
#configdrive_use_object_store = false


[dhcp]

#
# From ironic
#

# DHCP provider to use. "neutron" uses Neutron, and "none"
# uses a no-op provider. (string value)
dhcp_provider = none


[disk_partitioner]

#
# From ironic_lib.disk_partitioner
#

# After Ironic has completed creating the partition table, it
# continues to check for activity on the attached iSCSI device
# status at this interval prior to copying the image to the
# node, in seconds (integer value)
#check_device_interval = 1

# The maximum number of times to check that the device is not
# accessed by another process. If the device is still busy
# after that, the disk partitioning will be treated as having
# failed. (integer value)
#check_device_max_retries = 20


[disk_utils]

#
# From ironic_lib.disk_utils
#

# Size of EFI system partition in MiB when configuring UEFI
# systems for local boot. (integer value)
#efi_system_partition_size = 200

# Size of BIOS Boot partition in MiB when configuring GPT
# partitioned systems for local boot in BIOS. (integer value)
#bios_boot_partition_size = 1

# Block size to use when writing to the nodes disk. (string
# value)
#dd_block_size = 1M

# Maximum attempts to verify an iSCSI connection is active,
# sleeping 1 second between attempts. (integer value)
#iscsi_verify_attempts = 3

# Maximum number of attempts to try to read the partition.
# (integer value)
#partprobe_attempts = 10


[drac]

#
# From ironic
#

# Interval (in seconds) between periodic RAID job status
# checks to determine whether the asynchronous RAID
# configuration was successfully finished or not. (integer
# value)
#query_raid_config_job_status_interval = 120


[glance]

#
# From ironic
#

# A list of URL schemes that can be downloaded directly via
# the direct_url.  Currently supported schemes: [file]. (list
# value)
#allowed_direct_url_schemes =

# Authentication URL (string value)
#auth_url = <None>

# DEPRECATED: Authentication strategy to use when connecting
# to glance. (string value)
# Possible values:
# keystone - use the Identity service for authentication
# noauth - no authentication
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: To configure glance in noauth mode, set
# [glance]/auth_type=none and
# [glance]/endpoint_override=<GLANCE_API_ADDRESS> instead.
#auth_strategy = keystone

# Authentication type to load (string value)
# Deprecated group/name - [glance]/auth_plugin
#auth_type = <None>

# PEM encoded Certificate Authority to use when verifying
# HTTPs connections. (string value)
#cafile = <None>

# PEM encoded client certificate cert file (string value)
#certfile = <None>

# Collect per-API call timing information. (boolean value)
#collect_timing = false

# Optional domain ID to use with v3 and v2 parameters. It will
# be used for both the user and project domain in v3 and
# ignored in v2 authentication. (string value)
#default_domain_id = <None>

# Optional domain name to use with v3 API and v2 parameters.
# It will be used for both the user and project domain in v3
# and ignored in v2 authentication. (string value)
#default_domain_name = <None>

# Domain ID to scope to (string value)
#domain_id = <None>

# Domain name to scope to (string value)
#domain_name = <None>

# Always use this endpoint URL for requests for this client.
# NOTE: The unversioned endpoint should be specified here; to
# request a particular API version, use the `version`, `min-
# version`, and/or `max-version` options. (string value)
#endpoint_override = <None>

# DEPRECATED: Allow to perform insecure SSL (https) requests
# to glance. (boolean value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Use [glance]/insecure option instead.
#glance_api_insecure = false

# DEPRECATED: A list of the glance api servers available to
# ironic. Prefix with https:// for SSL-based glance API
# servers. Format is [hostname|IP]:port. (list value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Use [glance]/endpoint_override option to set the
# full load-balanced glance API URL instead.
#glance_api_servers = <None>

# DEPRECATED: Glance API version (1 or 2) to use. (integer
# value)
# Minimum value: 1
# Maximum value: 2
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Ironic will only support using Glance API version 2
# in the Queens release.
#glance_api_version = 2

# DEPRECATED: Optional path to a CA certificate bundle to be
# used to validate the SSL certificate served by glance. It is
# used when glance_api_insecure is set to False. (string
# value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Use [glance]/cafile option instead.
#glance_cafile = <None>

# Number of retries when downloading an image from glance.
# (integer value)
#glance_num_retries = 0

# Verify HTTPS connections. (boolean value)
#insecure = false

# PEM encoded client certificate key file (string value)
#keyfile = <None>

# The maximum major version of a given API, intended to be
# used as the upper bound of a range with min_version.
# Mutually exclusive with version. (string value)
#max_version = <None>

# The minimum major version of a given API, intended to be
# used as the lower bound of a range with max_version.
# Mutually exclusive with version. If min_version is given
# with no max_version it is as if max version is "latest".
# (string value)
#min_version = <None>

# User's password (string value)
#password = <None>

# Domain ID containing project (string value)
#project_domain_id = <None>

# Domain name containing project (string value)
#project_domain_name = <None>

# Project ID to scope to (string value)
# Deprecated group/name - [glance]/tenant_id
#project_id = <None>

# Project name to scope to (string value)
# Deprecated group/name - [glance]/tenant_name
#project_name = <None>

# The default region_name for endpoint URL discovery. (string
# value)
#region_name = <None>

# The default service_name for endpoint URL discovery. (string
# value)
#service_name = <None>

# The default service_type for endpoint URL discovery. (string
# value)
#service_type = image

# Log requests to multiple loggers. (boolean value)
#split_loggers = false

# The account that Glance uses to communicate with Swift. The
# format is "AUTH_uuid". "uuid" is the UUID for the account
# configured in the glance-api.conf. For example:
# "AUTH_a422b2-91f3-2f46-74b7-d7c9e8958f5d30". If not set, the
# default value is calculated based on the ID of the project
# used to access Swift (as set in the [swift] section). Swift
# temporary URL format:
# "endpoint_url/api_version/account/container/object_id"
# (string value)
#swift_account = <None>

# The Swift API version to create a temporary URL for.
# Defaults to "v1". Swift temporary URL format:
# "endpoint_url/api_version/account/container/object_id"
# (string value)
#swift_api_version = v1

# The Swift container Glance is configured to store its images
# in. Defaults to "glance", which is the default in glance-
# api.conf. Swift temporary URL format:
# "endpoint_url/api_version/account/container/object_id"
# (string value)
#swift_container = glance

# The "endpoint" (scheme, hostname, optional port) for the
# Swift URL of the form
# "endpoint_url/api_version/account/container/object_id". Do
# not include trailing "/". For example, use
# "https://swift.example.com". If using RADOS Gateway,
# endpoint may also contain /swift path; if it does not, it
# will be appended. Used for temporary URLs, will be fetched
# from the service catalog, if not provided. (string value)
#swift_endpoint_url = <None>

# This should match a config by the same name in the Glance
# configuration file. When set to 0, a single-tenant store
# will only use one container to store all images. When set to
# an integer value between 1 and 32, a single-tenant store
# will use multiple containers to store images, and this value
# will determine how many containers are created. (integer
# value)
#swift_store_multiple_containers_seed = 0

# Whether to cache generated Swift temporary URLs. Setting it
# to true is only useful when an image caching proxy is used.
# Defaults to False. (boolean value)
#swift_temp_url_cache_enabled = false

# The length of time in seconds that the temporary URL will be
# valid for. Defaults to 20 minutes. If some deploys get a 401
# response code when trying to download from the temporary
# URL, try raising this duration. This value must be greater
# than or equal to the value for
# swift_temp_url_expected_download_start_delay (integer value)
#swift_temp_url_duration = 1200

# This is the delay (in seconds) from the time of the deploy
# request (when the Swift temporary URL is generated) to when
# the IPA ramdisk starts up and URL is used for the image
# download. This value is used to check if the Swift temporary
# URL duration is large enough to let the image download
# begin. Also if temporary URL caching is enabled this will
# determine if a cached entry will still be valid when the
# download starts. swift_temp_url_duration value must be
# greater than or equal to this option's value. Defaults to 0.
# (integer value)
# Minimum value: 0
#swift_temp_url_expected_download_start_delay = 0

# The secret token given to Swift to allow temporary URL
# downloads. Required for temporary URLs. For the Swift
# backend, the key on the service project (as set in the
# [swift] section) is used by default. (string value)
#swift_temp_url_key = <None>

# Scope for system operations (string value)
#system_scope = <None>

# Tenant ID (string value)
#tenant_id = <None>

# Tenant Name (string value)
#tenant_name = <None>

# Timeout value for http requests (integer value)
#timeout = <None>

# Trust ID (string value)
#trust_id = <None>

# User's domain id (string value)
#user_domain_id = <None>

# User's domain name (string value)
#user_domain_name = <None>

# User id (string value)
#user_id = <None>

# Username (string value)
# Deprecated group/name - [glance]/user_name
#username = <None>

# List of interfaces, in order of preference, for endpoint
# URL. (list value)
#valid_interfaces = internal,public

# Minimum Major API version within a given Major API version
# for endpoint URL discovery. Mutually exclusive with
# min_version and max_version (string value)
#version = <None>


[healthcheck]

#
# From ironic
#

# Enable the health check endpoint at /healthcheck. Note that
# this is unauthenticated. More information is available at
# https://docs.openstack.org/oslo.middleware/latest/reference/healthcheck_plugins.html.
# (boolean value)
#enabled = false

#
# From oslo.middleware.healthcheck
#

# DEPRECATED: The path to respond to healtcheck requests on.
# (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
#path = /healthcheck

# Show more detailed information as part of the response
# (boolean value)
#detailed = false

# Additional backends that can perform health checks and
# report that information back as part of a request. (list
# value)
#backends =

# Check the presence of a file to determine if an application
# is running on a port. Used by DisableByFileHealthcheck
# plugin. (string value)
#disable_by_file_path = <None>

# Check the presence of a file based on a port to determine if
# an application is running on a port. Expects a "port:path"
# list of strings. Used by DisableByFilesPortsHealthcheck
# plugin. (list value)
#disable_by_file_paths =


[ilo]

#
# From ironic
#

# Timeout (in seconds) for iLO operations (integer value)
#client_timeout = 60

# Port to be used for iLO operations (port value)
# Minimum value: 0
# Maximum value: 65535
#client_port = 443

# The Swift iLO container to store data. (string value)
#swift_ilo_container = ironic_ilo_container

# Amount of time in seconds for Swift objects to auto-expire.
# (integer value)
#swift_object_expiry_timeout = 900

# Set this to True to use http web server to host floppy
# images and generated boot ISO. This requires http_root and
# http_url to be configured in the [deploy] section of the
# config file. If this is set to False, then Ironic will use
# Swift to host the floppy images and generated boot_iso.
# (boolean value)
#use_web_server_for_images = false

# Priority for reset_ilo clean step. (integer value)
#clean_priority_reset_ilo = 0

# Priority for reset_bios_to_default clean step. (integer
# value)
#clean_priority_reset_bios_to_default = 10

# Priority for reset_secure_boot_keys clean step. This step
# will reset the secure boot keys to manufacturing defaults.
# (integer value)
#clean_priority_reset_secure_boot_keys_to_default = 20

# Priority for clear_secure_boot_keys clean step. This step is
# not enabled by default. It can be enabled to clear all
# secure boot keys enrolled with iLO. (integer value)
#clean_priority_clear_secure_boot_keys = 0

# Priority for reset_ilo_credential clean step. This step
# requires "ilo_change_password" parameter to be updated in
# nodes's driver_info with the new password. (integer value)
#clean_priority_reset_ilo_credential = 30

# Number of times a power operation needs to be retried
# (integer value)
#power_retry = 6

# Amount of time in seconds to wait in between power
# operations (integer value)
#power_wait = 2

# CA certificate file to validate iLO. (string value)
#ca_file = <None>

# Default boot mode to be used in provisioning when
# "boot_mode" capability is not provided in the
# "properties/capabilities" of the node. The default is "auto"
# for backward compatibility. When "auto" is specified,
# default boot mode will be selected based on boot mode
# settings on the system. (string value)
# Possible values:
# auto - based on boot mode settings on the system
# bios - BIOS boot mode
# uefi - UEFI boot mode
#default_boot_mode = auto


[inspector]

#
# From ironic
#

# Authentication URL (string value)
#auth_url = <None>

# Authentication type to load (string value)
# Deprecated group/name - [inspector]/auth_plugin
#auth_type = <None>

# PEM encoded Certificate Authority to use when verifying
# HTTPs connections. (string value)
#cafile = <None>

# PEM encoded client certificate cert file (string value)
#certfile = <None>

# Collect per-API call timing information. (boolean value)
#collect_timing = false

# Optional domain ID to use with v3 and v2 parameters. It will
# be used for both the user and project domain in v3 and
# ignored in v2 authentication. (string value)
#default_domain_id = <None>

# Optional domain name to use with v3 API and v2 parameters.
# It will be used for both the user and project domain in v3
# and ignored in v2 authentication. (string value)
#default_domain_name = <None>

# Domain ID to scope to (string value)
#domain_id = <None>

# Domain name to scope to (string value)
#domain_name = <None>

# DEPRECATED: This option has no affect since the classic
# drivers removal. (boolean value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
#enabled = false

# Always use this endpoint URL for requests for this client.
# NOTE: The unversioned endpoint should be specified here; to
# request a particular API version, use the `version`, `min-
# version`, and/or `max-version` options. (string value)
#endpoint_override = <None>

# Verify HTTPS connections. (boolean value)
#insecure = false

# PEM encoded client certificate key file (string value)
#keyfile = <None>

# The maximum major version of a given API, intended to be
# used as the upper bound of a range with min_version.
# Mutually exclusive with version. (string value)
#max_version = <None>

# The minimum major version of a given API, intended to be
# used as the lower bound of a range with max_version.
# Mutually exclusive with version. If min_version is given
# with no max_version it is as if max version is "latest".
# (string value)
#min_version = <None>

# User's password (string value)
#password = <None>

# Domain ID containing project (string value)
#project_domain_id = <None>

# Domain name containing project (string value)
#project_domain_name = <None>

# Project ID to scope to (string value)
# Deprecated group/name - [inspector]/tenant_id
#project_id = <None>

# Project name to scope to (string value)
# Deprecated group/name - [inspector]/tenant_name
#project_name = <None>

# The default region_name for endpoint URL discovery. (string
# value)
#region_name = <None>

# The default service_name for endpoint URL discovery. (string
# value)
#service_name = <None>

# The default service_type for endpoint URL discovery. (string
# value)
#service_type = baremetal-introspection

# DEPRECATED: ironic-inspector HTTP endpoint. If this is not
# set, the service catalog will be used. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Use [inspector]/endpoint_override option instead to
# set a specific ironic-inspector API URL to connect to.
#service_url = <None>

# Log requests to multiple loggers. (boolean value)
#split_loggers = false

# period (in seconds) to check status of nodes on inspection
# (integer value)
#status_check_period = 60

# Scope for system operations (string value)
#system_scope = <None>

# Tenant ID (string value)
#tenant_id = <None>

# Tenant Name (string value)
#tenant_name = <None>

# Timeout value for http requests (integer value)
#timeout = <None>

# Trust ID (string value)
#trust_id = <None>

# User's domain id (string value)
#user_domain_id = <None>

# User's domain name (string value)
#user_domain_name = <None>

# User id (string value)
#user_id = <None>

# Username (string value)
# Deprecated group/name - [inspector]/user_name
#username = <None>

# List of interfaces, in order of preference, for endpoint
# URL. (list value)
#valid_interfaces = internal,public

# Minimum Major API version within a given Major API version
# for endpoint URL discovery. Mutually exclusive with
# min_version and max_version (string value)
#version = <None>


[ipmi]

#
# From ironic
#

# Maximum time in seconds to retry retryable IPMI operations.
# (An operation is retryable, for example, if the requested
# operation fails because the BMC is busy.) Setting this too
# high can cause the sync power state periodic task to hang
# when there are slow or unresponsive BMCs. (integer value)
#command_retry_timeout = 60

# Minimum time, in seconds, between IPMI operations sent to a
# server. There is a risk with some hardware that setting this
# too low may cause the BMC to crash. Recommended setting is 5
# seconds. (integer value)
#min_command_interval = 5


[irmc]

#
# From ironic
#

# Ironic conductor node's "NFS" or "CIFS" root path (string
# value)
#remote_image_share_root = /remote_image_share_root

# IP of remote image server (string value)
#remote_image_server = <None>

# Share type of virtual media (string value)
# Possible values:
# CIFS - CIFS (Common Internet File System) protocol
# NFS - NFS (Network File System) protocol
#remote_image_share_type = CIFS

# share name of remote_image_server (string value)
#remote_image_share_name = share

# User name of remote_image_server (string value)
#remote_image_user_name = <None>

# Password of remote_image_user_name (string value)
#remote_image_user_password = <None>

# Domain name of remote_image_user_name (string value)
#remote_image_user_domain =

# Port to be used for iRMC operations (port value)
# Minimum value: 0
# Maximum value: 65535
# Possible values:
# 443 - port 443
# 80 - port 80
#port = 443

# Authentication method to be used for iRMC operations (string
# value)
# Possible values:
# basic - Basic authentication
# digest - Digest authentication
#auth_method = basic

# Timeout (in seconds) for iRMC operations (integer value)
#client_timeout = 60

# Sensor data retrieval method. (string value)
# Possible values:
# ipmitool - IPMItool
# scci - Fujitsu SCCI (ServerView Common Command Interface)
#sensor_method = ipmitool

# SNMP protocol version (string value)
# Possible values:
# v1 - SNMPv1
# v2c - SNMPv2c
# v3 - SNMPv3
#snmp_version = v2c

# SNMP port (port value)
# Minimum value: 0
# Maximum value: 65535
#snmp_port = 161

# SNMP community. Required for versions "v1" and "v2c" (string
# value)
#snmp_community = public

# SNMP security name. Required for version "v3" (string value)
#snmp_security = <None>

# SNMP polling interval in seconds (integer value)
#snmp_polling_interval = 10

# Priority for restore_irmc_bios_config clean step. (integer
# value)
#clean_priority_restore_irmc_bios_config = 0

# List of vendor IDs and device IDs for GPU device to inspect.
# List items are in format vendorID/deviceID and separated by
# commas. GPU inspection will use this value to count the
# number of GPU device in a node. If this option is not
# defined, then leave out pci_gpu_devices in capabilities
# property. Sample gpu_ids value: 0x1000/0x0079,0x2100/0x0080
# (list value)
#gpu_ids =

# List of vendor IDs and device IDs for CPU FPGA to inspect.
# List items are in format vendorID/deviceID and separated by
# commas. CPU inspection will use this value to find existence
# of CPU FPGA in a node. If this option is not defined, then
# leave out CUSTOM_CPU_FPGA in node traits. Sample fpga_ids
# value: 0x1000/0x0079,0x2100/0x0080 (list value)
#fpga_ids =

# Interval (in seconds) between periodic RAID status checks to
# determine whether the asynchronous RAID configuration was
# successfully finished or not. Foreground Initialization
# (FGI) will start 5 minutes after creating virtual drives.
# (integer value)
# Minimum value: 1
#query_raid_config_fgi_status_interval = 300


[ironic_lib]

#
# From ironic_lib.utils
#

# Command that is prefixed to commands that are run as root.
# If not specified, no commands are run as root. (string
# value)
#root_helper = sudo ironic-rootwrap /etc/ironic/rootwrap.conf


[iscsi]

#
# From ironic
#

# The port number on which the iSCSI portal listens for
# incoming connections. (port value)
# Minimum value: 0
# Maximum value: 65535
#portal_port = 3260


[keystone_authtoken]

#
# From keystonemiddleware.auth_token
#

# Complete "public" Identity API endpoint. This endpoint
# should not be an "admin" endpoint, as it should be
# accessible by all end users. Unauthenticated clients are
# redirected to this endpoint to authenticate. Although this
# endpoint should ideally be unversioned, client support in
# the wild varies. If you're using a versioned v2 endpoint
# here, then this should *not* be the same endpoint the
# service user utilizes for validating tokens, because normal
# end users may not be able to reach that endpoint. (string
# value)
# Deprecated group/name - [keystone_authtoken]/auth_uri
#www_authenticate_uri = <None>

# DEPRECATED: Complete "public" Identity API endpoint. This
# endpoint should not be an "admin" endpoint, as it should be
# accessible by all end users. Unauthenticated clients are
# redirected to this endpoint to authenticate. Although this
# endpoint should ideally be unversioned, client support in
# the wild varies. If you're using a versioned v2 endpoint
# here, then this should *not* be the same endpoint the
# service user utilizes for validating tokens, because normal
# end users may not be able to reach that endpoint. This
# option is deprecated in favor of www_authenticate_uri and
# will be removed in the S release. (string value)
# This option is deprecated for removal since Queens.
# Its value may be silently ignored in the future.
# Reason: The auth_uri option is deprecated in favor of
# www_authenticate_uri and will be removed in the S  release.
#auth_uri = <None>

# API version of the admin Identity API endpoint. (string
# value)
#auth_version = <None>

# Do not handle authorization requests within the middleware,
# but delegate the authorization decision to downstream WSGI
# components. (boolean value)
#delay_auth_decision = false

# Request timeout value for communicating with Identity API
# server. (integer value)
#http_connect_timeout = <None>

# How many times are we trying to reconnect when communicating
# with Identity API Server. (integer value)
#http_request_max_retries = 3

# Request environment key where the Swift cache object is
# stored. When auth_token middleware is deployed with a Swift
# cache, use this option to have the middleware share a
# caching backend with swift. Otherwise, use the
# ``memcached_servers`` option instead. (string value)
#cache = <None>

# Required if identity server requires client certificate
# (string value)
#certfile = <None>

# Required if identity server requires client certificate
# (string value)
#keyfile = <None>

# A PEM encoded Certificate Authority to use when verifying
# HTTPs connections. Defaults to system CAs. (string value)
#cafile = <None>

# Verify HTTPS connections. (boolean value)
#insecure = false

# The region in which the identity server can be found.
# (string value)
#region_name = <None>

# DEPRECATED: Directory used to cache files related to PKI
# tokens. This option has been deprecated in the Ocata release
# and will be removed in the P release. (string value)
# This option is deprecated for removal since Ocata.
# Its value may be silently ignored in the future.
# Reason: PKI token format is no longer supported.
#signing_dir = <None>

# Optionally specify a list of memcached server(s) to use for
# caching. If left undefined, tokens will instead be cached
# in-process. (list value)
# Deprecated group/name - [keystone_authtoken]/memcache_servers
#memcached_servers = <None>

# In order to prevent excessive effort spent validating
# tokens, the middleware caches previously-seen tokens for a
# configurable duration (in seconds). Set to -1 to disable
# caching completely. (integer value)
#token_cache_time = 300

# DEPRECATED: Determines the frequency at which the list of
# revoked tokens is retrieved from the Identity service (in
# seconds). A high number of revocation events combined with a
# low cache duration may significantly reduce performance.
# Only valid for PKI tokens. This option has been deprecated
# in the Ocata release and will be removed in the P release.
# (integer value)
# This option is deprecated for removal since Ocata.
# Its value may be silently ignored in the future.
# Reason: PKI token format is no longer supported.
#revocation_cache_time = 10

# (Optional) If defined, indicate whether token data should be
# authenticated or authenticated and encrypted. If MAC, token
# data is authenticated (with HMAC) in the cache. If ENCRYPT,
# token data is encrypted and authenticated in the cache. If
# the value is not one of these options or empty, auth_token
# will raise an exception on initialization. (string value)
# Possible values:
# None - <No description provided>
# MAC - <No description provided>
# ENCRYPT - <No description provided>
#memcache_security_strategy = None

# (Optional, mandatory if memcache_security_strategy is
# defined) This string is used for key derivation. (string
# value)
#memcache_secret_key = <None>

# (Optional) Number of seconds memcached server is considered
# dead before it is tried again. (integer value)
#memcache_pool_dead_retry = 300

# (Optional) Maximum total number of open connections to every
# memcached server. (integer value)
#memcache_pool_maxsize = 10

# (Optional) Socket timeout in seconds for communicating with
# a memcached server. (integer value)
#memcache_pool_socket_timeout = 3

# (Optional) Number of seconds a connection to memcached is
# held unused in the pool before it is closed. (integer value)
#memcache_pool_unused_timeout = 60

# (Optional) Number of seconds that an operation will wait to
# get a memcached client connection from the pool. (integer
# value)
#memcache_pool_conn_get_timeout = 10

# (Optional) Use the advanced (eventlet safe) memcached client
# pool. The advanced pool will only work under python 2.x.
# (boolean value)
#memcache_use_advanced_pool = false

# (Optional) Indicate whether to set the X-Service-Catalog
# header. If False, middleware will not ask for service
# catalog on token validation and will not set the X-Service-
# Catalog header. (boolean value)
#include_service_catalog = true

# Used to control the use and type of token binding. Can be
# set to: "disabled" to not check token binding. "permissive"
# (default) to validate binding information if the bind type
# is of a form known to the server and ignore it if not.
# "strict" like "permissive" but if the bind type is unknown
# the token will be rejected. "required" any form of token
# binding is needed to be allowed. Finally the name of a
# binding method that must be present in tokens. (string
# value)
#enforce_token_bind = permissive

# DEPRECATED: If true, the revocation list will be checked for
# cached tokens. This requires that PKI tokens are configured
# on the identity server. (boolean value)
# This option is deprecated for removal since Ocata.
# Its value may be silently ignored in the future.
# Reason: PKI token format is no longer supported.
#check_revocations_for_cached = false

# DEPRECATED: Hash algorithms to use for hashing PKI tokens.
# This may be a single algorithm or multiple. The algorithms
# are those supported by Python standard hashlib.new(). The
# hashes will be tried in the order given, so put the
# preferred one first for performance. The result of the first
# hash will be stored in the cache. This will typically be set
# to multiple values only while migrating from a less secure
# algorithm to a more secure one. Once all the old tokens are
# expired this option should be set to a single value for
# better performance. (list value)
# This option is deprecated for removal since Ocata.
# Its value may be silently ignored in the future.
# Reason: PKI token format is no longer supported.
#hash_algorithms = md5

# A choice of roles that must be present in a service token.
# Service tokens are allowed to request that an expired token
# can be used and so this check should tightly control that
# only actual services should be sending this token. Roles
# here are applied as an ANY check so any role in this list
# must be present. For backwards compatibility reasons this
# currently only affects the allow_expired check. (list value)
#service_token_roles = service

# For backwards compatibility reasons we must let valid
# service tokens pass that don't pass the service_token_roles
# check as valid. Setting this true will become the default in
# a future release and should be enabled if possible. (boolean
# value)
#service_token_roles_required = false

# Authentication type to load (string value)
# Deprecated group/name - [keystone_authtoken]/auth_plugin
#auth_type = <None>

# Config Section from which to load plugin specific options
# (string value)
#auth_section = <None>


[matchmaker_redis]

#
# From oslo.messaging
#

# DEPRECATED: Host to locate redis. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#host = 127.0.0.1

# DEPRECATED: Use this port to connect to redis host. (port
# value)
# Minimum value: 0
# Maximum value: 65535
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#port = 6379

# DEPRECATED: Password for Redis server (optional). (string
# value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#password =

# DEPRECATED: List of Redis Sentinel hosts (fault tolerance
# mode), e.g., [host:port, host1:port ... ] (list value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#sentinel_hosts =

# Redis replica set name. (string value)
#sentinel_group_name = oslo-messaging-zeromq

# Time in ms to wait between connection attempts. (integer
# value)
#wait_timeout = 2000

# Time in ms to wait before the transaction is killed.
# (integer value)
#check_timeout = 20000

# Timeout in ms on blocking socket operations. (integer value)
#socket_timeout = 10000


[metrics]

#
# From ironic
#

# Backend for the agent ramdisk to use for metrics. Default
# possible backends are "noop" and "statsd". (string value)
#agent_backend = noop

# Prepend the hostname to all metric names sent by the agent
# ramdisk. The format of metric names is
# [global_prefix.][uuid.][host_name.]prefix.metric_name.
# (boolean value)
#agent_prepend_host = false

# Prepend the node's Ironic uuid to all metric names sent by
# the agent ramdisk. The format of metric names is
# [global_prefix.][uuid.][host_name.]prefix.metric_name.
# (boolean value)
#agent_prepend_uuid = false

# Split the prepended host value by "." and reverse it for
# metrics sent by the agent ramdisk (to better match the
# reverse hierarchical form of domain names). (boolean value)
#agent_prepend_host_reverse = true

# Prefix all metric names sent by the agent ramdisk with this
# value. The format of metric names is
# [global_prefix.][uuid.][host_name.]prefix.metric_name.
# (string value)
#agent_global_prefix = <None>

#
# From ironic_lib.metrics
#

# Backend to use for the metrics system. (string value)
# Possible values:
# noop - <No description provided>
# statsd - <No description provided>
#backend = noop

# Prepend the hostname to all metric names. The format of
# metric names is
# [global_prefix.][host_name.]prefix.metric_name. (boolean
# value)
#prepend_host = false

# Split the prepended host value by "." and reverse it (to
# better match the reverse hierarchical form of domain names).
# (boolean value)
#prepend_host_reverse = true

# Prefix all metric names with this value. By default, there
# is no global prefix. The format of metric names is
# [global_prefix.][host_name.]prefix.metric_name. (string
# value)
#global_prefix = <None>


[metrics_statsd]

#
# From ironic
#

# Host for the agent ramdisk to use with the statsd backend.
# This must be accessible from networks the agent is booted
# on. (string value)
#agent_statsd_host = localhost

# Port for the agent ramdisk to use with the statsd backend.
# (port value)
# Minimum value: 0
# Maximum value: 65535
#agent_statsd_port = 8125

#
# From ironic_lib.metrics_statsd
#

# Host for use with the statsd backend. (string value)
#statsd_host = localhost

# Port to use with the statsd backend. (port value)
# Minimum value: 0
# Maximum value: 65535
#statsd_port = 8125


[neutron]

#
# From ironic
#

# Authentication URL (string value)
#auth_url = <None>

# DEPRECATED: Authentication strategy to use when connecting
# to neutron. Running neutron in noauth mode (related to but
# not affected by this setting) is insecure and should only be
# used for testing. (string value)
# Possible values:
# keystone - use the Identity service for authentication
# noauth - no authentication
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: To configure neutron for noauth mode, set
# [neutron]/auth_type = none and
# [neutron]/endpoint_override=<NEUTRON_API_URL> instead
#auth_strategy = keystone

# Authentication type to load (string value)
# Deprecated group/name - [neutron]/auth_plugin
#auth_type = <None>

# PEM encoded Certificate Authority to use when verifying
# HTTPs connections. (string value)
#cafile = <None>

# PEM encoded client certificate cert file (string value)
#certfile = <None>

# Neutron network UUID or name for the ramdisk to be booted
# into for cleaning nodes. Required for "neutron" network
# interface. It is also required if cleaning nodes when using
# "flat" network interface or "neutron" DHCP provider. If a
# name is provided, it must be unique among all networks or
# cleaning will fail. (string value)
# Deprecated group/name - [neutron]/cleaning_network_uuid
#cleaning_network = <None>

# List of Neutron Security Group UUIDs to be applied during
# cleaning of the nodes. Optional for the "neutron" network
# interface and not used for the "flat" or "noop" network
# interfaces. If not specified, default security group is
# used. (list value)
#cleaning_network_security_groups =

# Collect per-API call timing information. (boolean value)
#collect_timing = false

# Optional domain ID to use with v3 and v2 parameters. It will
# be used for both the user and project domain in v3 and
# ignored in v2 authentication. (string value)
#default_domain_id = <None>

# Optional domain name to use with v3 API and v2 parameters.
# It will be used for both the user and project domain in v3
# and ignored in v2 authentication. (string value)
#default_domain_name = <None>

# Domain ID to scope to (string value)
#domain_id = <None>

# Domain name to scope to (string value)
#domain_name = <None>

# Always use this endpoint URL for requests for this client.
# NOTE: The unversioned endpoint should be specified here; to
# request a particular API version, use the `version`, `min-
# version`, and/or `max-version` options. (string value)
#endpoint_override = <None>

# Verify HTTPS connections. (boolean value)
#insecure = false

# PEM encoded client certificate key file (string value)
#keyfile = <None>

# The maximum major version of a given API, intended to be
# used as the upper bound of a range with min_version.
# Mutually exclusive with version. (string value)
#max_version = <None>

# The minimum major version of a given API, intended to be
# used as the lower bound of a range with max_version.
# Mutually exclusive with version. If min_version is given
# with no max_version it is as if max version is "latest".
# (string value)
#min_version = <None>

# User's password (string value)
#password = <None>

# Delay value to wait for Neutron agents to setup sufficient
# DHCP configuration for port. (integer value)
# Minimum value: 0
#port_setup_delay = 0

# Domain ID containing project (string value)
#project_domain_id = <None>

# Domain name containing project (string value)
#project_domain_name = <None>

# Project ID to scope to (string value)
# Deprecated group/name - [neutron]/tenant_id
#project_id = <None>

# Project name to scope to (string value)
# Deprecated group/name - [neutron]/tenant_name
#project_name = <None>

# Neutron network UUID or name for the ramdisk to be booted
# into for provisioning nodes. Required for "neutron" network
# interface. If a name is provided, it must be unique among
# all networks or deploy will fail. (string value)
# Deprecated group/name - [neutron]/provisioning_network_uuid
#provisioning_network = <None>

# List of Neutron Security Group UUIDs to be applied during
# provisioning of the nodes. Optional for the "neutron"
# network interface and not used for the "flat" or "noop"
# network interfaces. If not specified, default security group
# is used. (list value)
#provisioning_network_security_groups =

# The default region_name for endpoint URL discovery. (string
# value)
#region_name = <None>

# Neutron network UUID or name for booting the ramdisk for
# rescue mode. This is not the network that the rescue ramdisk
# will use post-boot -- the tenant network is used for that.
# Required for "neutron" network interface, if rescue mode
# will be used. It is not used for the "flat" or "noop"
# network interfaces. If a name is provided, it must be unique
# among all networks or rescue will fail. (string value)
#rescuing_network = <None>

# List of Neutron Security Group UUIDs to be applied during
# the node rescue process. Optional for the "neutron" network
# interface and not used for the "flat" or "noop" network
# interfaces. If not specified, the default security group is
# used. (list value)
#rescuing_network_security_groups =

# Client retries in the case of a failed request. (integer
# value)
#retries = 3

# The default service_name for endpoint URL discovery. (string
# value)
#service_name = <None>

# The default service_type for endpoint URL discovery. (string
# value)
#service_type = network

# Log requests to multiple loggers. (boolean value)
#split_loggers = false

# Scope for system operations (string value)
#system_scope = <None>

# Tenant ID (string value)
#tenant_id = <None>

# Tenant Name (string value)
#tenant_name = <None>

# Timeout value for http requests (integer value)
#timeout = <None>

# Trust ID (string value)
#trust_id = <None>

# DEPRECATED: URL for connecting to neutron. Default value
# translates to 'http://$my_ip:9696' when auth_strategy is
# 'noauth', and to discovery from Keystone catalog when
# auth_strategy is 'keystone'. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Use [neutron]/endpoint_override option instead. It
# has no default value and must be set explicitly if required
# to connect to specific neutron URL, for example in stand
# alone mode when [neutron]/auth_type is 'none'.
#url = <None>

# DEPRECATED: Timeout value for connecting to neutron in
# seconds. (integer value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Set the desired value explicitly using the
# [neutron]/timeout option instead.
#url_timeout = 30

# User's domain id (string value)
#user_domain_id = <None>

# User's domain name (string value)
#user_domain_name = <None>

# User id (string value)
#user_id = <None>

# Username (string value)
# Deprecated group/name - [neutron]/user_name
#username = <None>

# List of interfaces, in order of preference, for endpoint
# URL. (list value)
#valid_interfaces = internal,public

# Minimum Major API version within a given Major API version
# for endpoint URL discovery. Mutually exclusive with
# min_version and max_version (string value)
#version = <None>


[oneview]

#
# From ironic
#

# URL where OneView is available. (string value)
#manager_url = <None>

# OneView username to be used. (string value)
#username = <None>

# OneView password to be used. (string value)
#password = <None>

# Option to allow insecure connection with OneView. (boolean
# value)
#allow_insecure_connections = false

# Path to CA certificate. (string value)
#tls_cacert_file = <None>

# Whether to enable the periodic tasks for OneView driver be
# aware when OneView hardware resources are taken and released
# by Ironic or OneView users and proactively manage nodes in
# clean fail state according to Dynamic Allocation model of
# hardware resources allocation in OneView. (boolean value)
#enable_periodic_tasks = true

# Period (in seconds) for periodic tasks to be executed when
# enable_periodic_tasks=True. (integer value)
#periodic_check_interval = 300


[oslo_concurrency]

#
# From oslo.concurrency
#

# Enables or disables inter-process locks. (boolean value)
#disable_process_locking = false

# Directory to use for lock files.  For security, the
# specified directory should only be writable by the user
# running the processes that need locking. Defaults to
# environment variable OSLO_LOCK_PATH. If external locks are
# used, a lock path must be set. (string value)
#lock_path = <None>


[oslo_messaging_amqp]

#
# From oslo.messaging
#

# Name for the AMQP container. must be globally unique.
# Defaults to a generated UUID (string value)
#container_name = <None>

# Timeout for inactive connections (in seconds) (integer
# value)
#idle_timeout = 0

# Debug: dump AMQP frames to stdout (boolean value)
#trace = false

# Attempt to connect via SSL. If no other ssl-related
# parameters are given, it will use the system's CA-bundle to
# verify the server's certificate. (boolean value)
#ssl = false

# CA certificate PEM file used to verify the server's
# certificate (string value)
#ssl_ca_file =

# Self-identifying certificate PEM file for client
# authentication (string value)
#ssl_cert_file =

# Private key PEM file used to sign ssl_cert_file certificate
# (optional) (string value)
#ssl_key_file =

# Password for decrypting ssl_key_file (if encrypted) (string
# value)
#ssl_key_password = <None>

# By default SSL checks that the name in the server's
# certificate matches the hostname in the transport_url. In
# some configurations it may be preferable to use the virtual
# hostname instead, for example if the server uses the Server
# Name Indication TLS extension (rfc6066) to provide a
# certificate per virtual host. Set ssl_verify_vhost to True
# if the server's SSL certificate uses the virtual host name
# instead of the DNS name. (boolean value)
#ssl_verify_vhost = false

# DEPRECATED: Accept clients using either SSL or plain TCP
# (boolean value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Not applicable - not a SSL server
#allow_insecure_clients = false

# Space separated list of acceptable SASL mechanisms (string
# value)
#sasl_mechanisms =

# Path to directory that contains the SASL configuration
# (string value)
#sasl_config_dir =

# Name of configuration file (without .conf suffix) (string
# value)
#sasl_config_name =

# SASL realm to use if no realm present in username (string
# value)
#sasl_default_realm =

# DEPRECATED: User name for message broker authentication
# (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Should use configuration option transport_url to
# provide the username.
#username =

# DEPRECATED: Password for message broker authentication
# (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Should use configuration option transport_url to
# provide the password.
#password =

# Seconds to pause before attempting to re-connect. (integer
# value)
# Minimum value: 1
#connection_retry_interval = 1

# Increase the connection_retry_interval by this many seconds
# after each unsuccessful failover attempt. (integer value)
# Minimum value: 0
#connection_retry_backoff = 2

# Maximum limit for connection_retry_interval +
# connection_retry_backoff (integer value)
# Minimum value: 1
#connection_retry_interval_max = 30

# Time to pause between re-connecting an AMQP 1.0 link that
# failed due to a recoverable error. (integer value)
# Minimum value: 1
#link_retry_delay = 10

# The maximum number of attempts to re-send a reply message
# which failed due to a recoverable error. (integer value)
# Minimum value: -1
#default_reply_retry = 0

# The deadline for an rpc reply message delivery. (integer
# value)
# Minimum value: 5
#default_reply_timeout = 30

# The deadline for an rpc cast or call message delivery. Only
# used when caller does not provide a timeout expiry. (integer
# value)
# Minimum value: 5
#default_send_timeout = 30

# The deadline for a sent notification message delivery. Only
# used when caller does not provide a timeout expiry. (integer
# value)
# Minimum value: 5
#default_notify_timeout = 30

# The duration to schedule a purge of idle sender links.
# Detach link after expiry. (integer value)
# Minimum value: 1
#default_sender_link_timeout = 600

# Indicates the addressing mode used by the driver.
# Permitted values:
# 'legacy'   - use legacy non-routable addressing
# 'routable' - use routable addresses
# 'dynamic'  - use legacy addresses if the message bus does
# not support routing otherwise use routable addressing
# (string value)
#addressing_mode = dynamic

# Enable virtual host support for those message buses that do
# not natively support virtual hosting (such as qpidd). When
# set to true the virtual host name will be added to all
# message bus addresses, effectively creating a private
# 'subnet' per virtual host. Set to False if the message bus
# supports virtual hosting using the 'hostname' field in the
# AMQP 1.0 Open performative as the name of the virtual host.
# (boolean value)
#pseudo_vhost = true

# address prefix used when sending to a specific server
# (string value)
#server_request_prefix = exclusive

# address prefix used when broadcasting to all servers (string
# value)
#broadcast_prefix = broadcast

# address prefix when sending to any server in group (string
# value)
#group_request_prefix = unicast

# Address prefix for all generated RPC addresses (string
# value)
#rpc_address_prefix = openstack.org/om/rpc

# Address prefix for all generated Notification addresses
# (string value)
#notify_address_prefix = openstack.org/om/notify

# Appended to the address prefix when sending a fanout
# message. Used by the message bus to identify fanout
# messages. (string value)
#multicast_address = multicast

# Appended to the address prefix when sending to a particular
# RPC/Notification server. Used by the message bus to identify
# messages sent to a single destination. (string value)
#unicast_address = unicast

# Appended to the address prefix when sending to a group of
# consumers. Used by the message bus to identify messages that
# should be delivered in a round-robin fashion across
# consumers. (string value)
#anycast_address = anycast

# Exchange name used in notification addresses.
# Exchange name resolution precedence:
# Target.exchange if set
# else default_notification_exchange if set
# else control_exchange if set
# else 'notify' (string value)
#default_notification_exchange = <None>

# Exchange name used in RPC addresses.
# Exchange name resolution precedence:
# Target.exchange if set
# else default_rpc_exchange if set
# else control_exchange if set
# else 'rpc' (string value)
#default_rpc_exchange = <None>

# Window size for incoming RPC Reply messages. (integer value)
# Minimum value: 1
#reply_link_credit = 200

# Window size for incoming RPC Request messages (integer
# value)
# Minimum value: 1
#rpc_server_credit = 100

# Window size for incoming Notification messages (integer
# value)
# Minimum value: 1
#notify_server_credit = 100

# Send messages of this type pre-settled.
# Pre-settled messages will not receive acknowledgement
# from the peer. Note well: pre-settled messages may be
# silently discarded if the delivery fails.
# Permitted values:
# 'rpc-call' - send RPC Calls pre-settled
# 'rpc-reply'- send RPC Replies pre-settled
# 'rpc-cast' - Send RPC Casts pre-settled
# 'notify'   - Send Notifications pre-settled
#  (multi valued)
#pre_settled = rpc-cast
#pre_settled = rpc-reply


[oslo_messaging_kafka]

#
# From oslo.messaging
#

# DEPRECATED: Default Kafka broker Host (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#kafka_default_host = localhost

# DEPRECATED: Default Kafka broker Port (port value)
# Minimum value: 0
# Maximum value: 65535
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#kafka_default_port = 9092

# Max fetch bytes of Kafka consumer (integer value)
#kafka_max_fetch_bytes = 1048576

# Default timeout(s) for Kafka consumers (floating point
# value)
#kafka_consumer_timeout = 1.0

# DEPRECATED: Pool Size for Kafka Consumers (integer value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Driver no longer uses connection pool.
#pool_size = 10

# DEPRECATED: The pool size limit for connections expiration
# policy (integer value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Driver no longer uses connection pool.
#conn_pool_min_size = 2

# DEPRECATED: The time-to-live in sec of idle connections in
# the pool (integer value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Driver no longer uses connection pool.
#conn_pool_ttl = 1200

# Group id for Kafka consumer. Consumers in one group will
# coordinate message consumption (string value)
#consumer_group = oslo_messaging_consumer

# Upper bound on the delay for KafkaProducer batching in
# seconds (floating point value)
#producer_batch_timeout = 0.0

# Size of batch for the producer async send (integer value)
#producer_batch_size = 16384

# Enable asynchronous consumer commits (boolean value)
#enable_auto_commit = false

# The maximum number of records returned in a poll call
# (integer value)
#max_poll_records = 500

# Protocol used to communicate with brokers (string value)
# Possible values:
# PLAINTEXT - <No description provided>
# SASL_PLAINTEXT - <No description provided>
# SSL - <No description provided>
# SASL_SSL - <No description provided>
#security_protocol = PLAINTEXT

# Mechanism when security protocol is SASL (string value)
#sasl_mechanism = PLAIN

# CA certificate PEM file used to verify the server
# certificate (string value)
#ssl_cafile =


[oslo_messaging_notifications]

#
# From oslo.messaging
#

# The Drivers(s) to handle sending notifications. Possible
# values are messaging, messagingv2, routing, log, test, noop
# (multi valued)
# Deprecated group/name - [DEFAULT]/notification_driver
#driver =

# A URL representing the messaging driver to use for
# notifications. If not set, we fall back to the same
# configuration used for RPC. (string value)
# Deprecated group/name - [DEFAULT]/notification_transport_url
#transport_url = <None>

# AMQP topic used for OpenStack notifications. (list value)
# Deprecated group/name - [rpc_notifier2]/topics
# Deprecated group/name - [DEFAULT]/notification_topics
#topics = notifications

# The maximum number of attempts to re-send a notification
# message which failed to be delivered due to a recoverable
# error. 0 - No retry, -1 - indefinite (integer value)
#retry = -1


[oslo_messaging_rabbit]

#
# From oslo.messaging
#

# Use durable queues in AMQP. (boolean value)
# Deprecated group/name - [DEFAULT]/amqp_durable_queues
# Deprecated group/name - [DEFAULT]/rabbit_durable_queues
#amqp_durable_queues = false

# Auto-delete queues in AMQP. (boolean value)
#amqp_auto_delete = false

# Connect over SSL. (boolean value)
# Deprecated group/name - [oslo_messaging_rabbit]/rabbit_use_ssl
#ssl = false

# SSL version to use (valid only if SSL enabled). Valid values
# are TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1, and TLSv1_2 may
# be available on some distributions. (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_version
#ssl_version =

# SSL key file (valid only if SSL enabled). (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_keyfile
#ssl_key_file =

# SSL cert file (valid only if SSL enabled). (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_certfile
#ssl_cert_file =

# SSL certification authority file (valid only if SSL
# enabled). (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_ca_certs
#ssl_ca_file =

# How long to wait before reconnecting in response to an AMQP
# consumer cancel notification. (floating point value)
#kombu_reconnect_delay = 1.0

# EXPERIMENTAL: Possible values are: gzip, bz2. If not set
# compression will not be used. This option may not be
# available in future versions. (string value)
#kombu_compression = <None>

# How long to wait a missing client before abandoning to send
# it its replies. This value should not be longer than
# rpc_response_timeout. (integer value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_reconnect_timeout
#kombu_missing_consumer_retry_timeout = 60

# Determines how the next RabbitMQ node is chosen in case the
# one we are currently connected to becomes unavailable. Takes
# effect only if more than one RabbitMQ node is provided in
# config. (string value)
# Possible values:
# round-robin - <No description provided>
# shuffle - <No description provided>
#kombu_failover_strategy = round-robin

# DEPRECATED: The RabbitMQ broker address where a single node
# is used. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#rabbit_host = localhost

# DEPRECATED: The RabbitMQ broker port where a single node is
# used. (port value)
# Minimum value: 0
# Maximum value: 65535
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#rabbit_port = 5672

# DEPRECATED: RabbitMQ HA cluster host:port pairs. (list
# value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#rabbit_hosts = $rabbit_host:$rabbit_port

# DEPRECATED: The RabbitMQ userid. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#rabbit_userid = guest

# DEPRECATED: The RabbitMQ password. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#rabbit_password = guest

# The RabbitMQ login method. (string value)
# Possible values:
# PLAIN - <No description provided>
# AMQPLAIN - <No description provided>
# RABBIT-CR-DEMO - <No description provided>
#rabbit_login_method = AMQPLAIN

# DEPRECATED: The RabbitMQ virtual host. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Replaced by [DEFAULT]/transport_url
#rabbit_virtual_host = /

# How frequently to retry connecting with RabbitMQ. (integer
# value)
#rabbit_retry_interval = 1

# How long to backoff for between retries when connecting to
# RabbitMQ. (integer value)
#rabbit_retry_backoff = 2

# Maximum interval of RabbitMQ connection retries. Default is
# 30 seconds. (integer value)
#rabbit_interval_max = 30

# DEPRECATED: Maximum number of RabbitMQ connection retries.
# Default is 0 (infinite retry count). (integer value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
#rabbit_max_retries = 0

# Try to use HA queues in RabbitMQ (x-ha-policy: all). If you
# change this option, you must wipe the RabbitMQ database. In
# RabbitMQ 3.0, queue mirroring is no longer controlled by the
# x-ha-policy argument when declaring a queue. If you just
# want to make sure that all queues (except those with auto-
# generated names) are mirrored across all nodes, run:
# "rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode":
# "all"}' " (boolean value)
#rabbit_ha_queues = false

# Positive integer representing duration in seconds for queue
# TTL (x-expires). Queues which are unused for the duration of
# the TTL are automatically deleted. The parameter affects
# only reply and fanout queues. (integer value)
# Minimum value: 1
#rabbit_transient_queues_ttl = 1800

# Specifies the number of messages to prefetch. Setting to
# zero allows unlimited messages. (integer value)
#rabbit_qos_prefetch_count = 0

# Number of seconds after which the Rabbit broker is
# considered down if heartbeat's keep-alive fails (0 disable
# the heartbeat). EXPERIMENTAL (integer value)
#heartbeat_timeout_threshold = 60

# How often times during the heartbeat_timeout_threshold we
# check the heartbeat. (integer value)
#heartbeat_rate = 2


[oslo_messaging_zmq]

#
# From oslo.messaging
#

# ZeroMQ bind address. Should be a wildcard (*), an ethernet
# interface, or IP. The "host" option should point or resolve
# to this address. (string value)
#rpc_zmq_bind_address = *

# MatchMaker driver. (string value)
# Possible values:
# redis - <No description provided>
# sentinel - <No description provided>
# dummy - <No description provided>
#rpc_zmq_matchmaker = redis

# Number of ZeroMQ contexts, defaults to 1. (integer value)
#rpc_zmq_contexts = 1

# Maximum number of ingress messages to locally buffer per
# topic. Default is unlimited. (integer value)
#rpc_zmq_topic_backlog = <None>

# Directory for holding IPC sockets. (string value)
#rpc_zmq_ipc_dir = /var/run/openstack

# Name of this node. Must be a valid hostname, FQDN, or IP
# address. Must match "host" option, if running Nova. (string
# value)
#rpc_zmq_host = localhost

# Number of seconds to wait before all pending messages will
# be sent after closing a socket. The default value of -1
# specifies an infinite linger period. The value of 0
# specifies no linger period. Pending messages shall be
# discarded immediately when the socket is closed. Positive
# values specify an upper bound for the linger period.
# (integer value)
# Deprecated group/name - [DEFAULT]/rpc_cast_timeout
#zmq_linger = -1

# The default number of seconds that poll should wait. Poll
# raises timeout exception when timeout expired. (integer
# value)
#rpc_poll_timeout = 1

# Expiration timeout in seconds of a name service record about
# existing target ( < 0 means no timeout). (integer value)
#zmq_target_expire = 300

# Update period in seconds of a name service record about
# existing target. (integer value)
#zmq_target_update = 180

# Use PUB/SUB pattern for fanout methods. PUB/SUB always uses
# proxy. (boolean value)
#use_pub_sub = false

# Use ROUTER remote proxy. (boolean value)
#use_router_proxy = false

# This option makes direct connections dynamic or static. It
# makes sense only with use_router_proxy=False which means to
# use direct connections for direct message types (ignored
# otherwise). (boolean value)
#use_dynamic_connections = false

# How many additional connections to a host will be made for
# failover reasons. This option is actual only in dynamic
# connections mode. (integer value)
#zmq_failover_connections = 2

# Minimal port number for random ports range. (port value)
# Minimum value: 0
# Maximum value: 65535
#rpc_zmq_min_port = 49153

# Maximal port number for random ports range. (integer value)
# Minimum value: 1
# Maximum value: 65536
#rpc_zmq_max_port = 65536

# Number of retries to find free port number before fail with
# ZMQBindError. (integer value)
#rpc_zmq_bind_port_retries = 100

# Default serialization mechanism for
# serializing/deserializing outgoing/incoming messages (string
# value)
# Possible values:
# json - <No description provided>
# msgpack - <No description provided>
#rpc_zmq_serialization = json

# This option configures round-robin mode in zmq socket. True
# means not keeping a queue when server side disconnects.
# False means to keep queue and messages even if server is
# disconnected, when the server appears we send all
# accumulated messages to it. (boolean value)
#zmq_immediate = true

# Enable/disable TCP keepalive (KA) mechanism. The default
# value of -1 (or any other negative value) means to skip any
# overrides and leave it to OS default; 0 and 1 (or any other
# positive value) mean to disable and enable the option
# respectively. (integer value)
#zmq_tcp_keepalive = -1

# The duration between two keepalive transmissions in idle
# condition. The unit is platform dependent, for example,
# seconds in Linux, milliseconds in Windows etc. The default
# value of -1 (or any other negative value and 0) means to
# skip any overrides and leave it to OS default. (integer
# value)
#zmq_tcp_keepalive_idle = -1

# The number of retransmissions to be carried out before
# declaring that remote end is not available. The default
# value of -1 (or any other negative value and 0) means to
# skip any overrides and leave it to OS default. (integer
# value)
#zmq_tcp_keepalive_cnt = -1

# The duration between two successive keepalive
# retransmissions, if acknowledgement to the previous
# keepalive transmission is not received. The unit is platform
# dependent, for example, seconds in Linux, milliseconds in
# Windows etc. The default value of -1 (or any other negative
# value and 0) means to skip any overrides and leave it to OS
# default. (integer value)
#zmq_tcp_keepalive_intvl = -1

# Maximum number of (green) threads to work concurrently.
# (integer value)
#rpc_thread_pool_size = 100

# Expiration timeout in seconds of a sent/received message
# after which it is not tracked anymore by a client/server.
# (integer value)
#rpc_message_ttl = 300

# Wait for message acknowledgements from receivers. This
# mechanism works only via proxy without PUB/SUB. (boolean
# value)
#rpc_use_acks = false

# Number of seconds to wait for an ack from a cast/call. After
# each retry attempt this timeout is multiplied by some
# specified multiplier. (integer value)
#rpc_ack_timeout_base = 15

# Number to multiply base ack timeout by after each retry
# attempt. (integer value)
#rpc_ack_timeout_multiplier = 2

# Default number of message sending attempts in case of any
# problems occurred: positive value N means at most N retries,
# 0 means no retries, None or -1 (or any other negative
# values) mean to retry forever. This option is used only if
# acknowledgments are enabled. (integer value)
#rpc_retry_attempts = 3

# List of publisher hosts SubConsumer can subscribe on. This
# option has higher priority then the default publishers list
# taken from the matchmaker. (list value)
#subscribe_on =


[oslo_policy]

#
# From oslo.policy
#

# This option controls whether or not to enforce scope when
# evaluating policies. If ``True``, the scope of the token
# used in the request is compared to the ``scope_types`` of
# the policy being enforced. If the scopes do not match, an
# ``InvalidScope`` exception will be raised. If ``False``, a
# message will be logged informing operators that policies are
# being invoked with mismatching scope. (boolean value)
#enforce_scope = false

# The file that defines policies. (string value)
#policy_file = policy.json

# Default rule. Enforced when a requested rule is not found.
# (string value)
#policy_default_rule = default

# Directories where policy configuration files are stored.
# They can be relative to any directory in the search path
# defined by the config_dir option, or absolute paths. The
# file defined by policy_file must exist for these directories
# to be searched.  Missing or empty directories are ignored.
# (multi valued)
#policy_dirs = policy.d

# Content Type to send and receive data for REST based policy
# check (string value)
# Possible values:
# application/x-www-form-urlencoded - <No description
# provided>
# application/json - <No description provided>
#remote_content_type = application/x-www-form-urlencoded

# server identity verification for REST based policy check
# (boolean value)
#remote_ssl_verify_server_crt = false

# Absolute path to ca cert file for REST based policy check
# (string value)
#remote_ssl_ca_crt_file = <None>

# Absolute path to client cert for REST based policy check
# (string value)
#remote_ssl_client_crt_file = <None>

# Absolute path client key file REST based policy check
# (string value)
#remote_ssl_client_key_file = <None>


[profiler]

#
# From osprofiler
#

#
# Enable the profiling for all services on this node.
#
# Default value is False (fully disable the profiling
# feature).
#
# Possible values:
#
# * True: Enables the feature
# * False: Disables the feature. The profiling cannot be
# started via this project
#   operations. If the profiling is triggered by another
# project, this project
#   part will be empty.
#  (boolean value)
# Deprecated group/name - [profiler]/profiler_enabled
#enabled = false

#
# Enable SQL requests profiling in services.
#
# Default value is False (SQL requests won't be traced).
#
# Possible values:
#
# * True: Enables SQL requests profiling. Each SQL query will
# be part of the
#   trace and can the be analyzed by how much time was spent
# for that.
# * False: Disables SQL requests profiling. The spent time is
# only shown on a
#   higher level of operations. Single SQL queries cannot be
# analyzed this way.
#  (boolean value)
#trace_sqlalchemy = false

#
# Secret key(s) to use for encrypting context data for
# performance profiling.
#
# This string value should have the following format:
# <key1>[,<key2>,...<keyn>],
# where each key is some random string. A user who triggers
# the profiling via
# the REST API has to set one of these keys in the headers of
# the REST API call
# to include profiling results of this node for this
# particular project.
#
# Both "enabled" flag and "hmac_keys" config options should be
# set to enable
# profiling. Also, to generate correct profiling information
# across all services
# at least one key needs to be consistent between OpenStack
# projects. This
# ensures it can be used from client side to generate the
# trace, containing
# information from all possible resources.
#  (string value)
#hmac_keys = SECRET_KEY

#
# Connection string for a notifier backend.
#
# Default value is ``messaging://`` which sets the notifier to
# oslo_messaging.
#
# Examples of possible values:
#
# * ``messaging://`` - use oslo_messaging driver for sending
# spans.
# * ``redis://127.0.0.1:6379`` - use redis driver for sending
# spans.
# * ``mongodb://127.0.0.1:27017`` - use mongodb driver for
# sending spans.
# * ``elasticsearch://127.0.0.1:9200`` - use elasticsearch
# driver for sending
#   spans.
# * ``jaeger://127.0.0.1:6831`` - use jaeger tracing as driver
# for sending spans.
#  (string value)
#connection_string = messaging://

#
# Document type for notification indexing in elasticsearch.
#  (string value)
#es_doc_type = notification

#
# This parameter is a time value parameter (for example:
# es_scroll_time=2m),
# indicating for how long the nodes that participate in the
# search will maintain
# relevant resources in order to continue and support it.
#  (string value)
#es_scroll_time = 2m

#
# Elasticsearch splits large requests in batches. This
# parameter defines
# maximum size of each batch (for example:
# es_scroll_size=10000).
#  (integer value)
#es_scroll_size = 10000

#
# Redissentinel provides a timeout option on the connections.
# This parameter defines that timeout (for example:
# socket_timeout=0.1).
#  (floating point value)
#socket_timeout = 0.1

#
# Redissentinel uses a service name to identify a master redis
# service.
# This parameter defines the name (for example:
# ``sentinal_service_name=mymaster``).
#  (string value)
#sentinel_service_name = mymaster

#
# Enable filter traces that contain error/exception to a
# separated place.
#
# Default value is set to False.
#
# Possible values:
#
# * True: Enable filter traces that contain error/exception.
# * False: Disable the filter.
#  (boolean value)
#filter_error_trace = false


[pxe]

#
# From ironic
#

# Additional append parameters for baremetal PXE boot. (string
# value)
pxe_append_params = {{ .Values.config.pxe.pxe_append_params | default "nofb nomodeset vga=normal" }}

# Default file system format for ephemeral partition, if one
# is created. (string value)
#default_ephemeral_format = ext4

# On the ironic-conductor node, directory where images are
# stored on disk. (string value)
images_path =  /storage/httpboot/images

# On the ironic-conductor node, directory where master
# instance images are stored on disk. Setting to <None>
# disables image caching. (string value)
instance_master_path = /storage/httpboot/master-path

# Maximum size (in MiB) of cache for master images, including
# those in use. (integer value)
#image_cache_size = 20480

# Maximum TTL (in minutes) for old master images in cache.
# (integer value)
#image_cache_ttl = 10080

# On ironic-conductor node, template file for PXE
# configuration. (string value)
pxe_config_template = {{ .Values.config.pxe.pxe_config_template | default "$pybasedir/drivers/modules/pxe_config.template" }}

# On ironic-conductor node, template file for PXE
# configuration for UEFI boot loader. (string value)
#uefi_pxe_config_template = $pybasedir/drivers/modules/pxe_grub_config.template

# On ironic-conductor node, template file for PXE
# configuration per node architecture. For example:
# aarch64:/opt/share/grubaa64_pxe_config.template (dict value)
#pxe_config_template_by_arch =

# IP address of ironic-conductor node's TFTP server. (string
# value)
tftp_server =  {{ .Values.tftp.externalIPs | first }}

# ironic-conductor node's TFTP root path. The ironic-conductor
# must have read/write access to this path. (string value)
tftp_root = /storage/tftpboot

# On ironic-conductor node, directory where master TFTP images
# are stored on disk. Setting to <None> disables image
# caching. (string value)
tftp_master_path = /storage/tftpboot/master-path

# The permission that will be applied to the TFTP folders upon
# creation. This should be set to the permission such that the
# tftpserver has access to read the contents of the configured
# TFTP folder. This setting is only required when the
# operating system's umask is restrictive such that ironic-
# conductor is creating files that cannot be read by the TFTP
# server. Setting to <None> will result in the operating
# system's umask to be utilized for the creation of new tftp
# folders. It is recommended that an octal representation is
# specified. For example: 0o755 (integer value)
#dir_permission = <None>

# Bootfile DHCP parameter. (string value)
#pxe_bootfile_name = pxelinux.0

# Directory in which to create symbolic links which represent
# the MAC or IP address of the the ports on a node and allow
# boot loaders to load the PXE file for the node. This
# directory name is relative to the PXE or iPXE folders.
# (string value)
#pxe_config_subdir = pxelinux.cfg

# Bootfile DHCP parameter for UEFI boot mode. (string value)
#uefi_pxe_bootfile_name = bootx64.efi

# Bootfile DHCP parameter per node architecture. For example:
# aarch64:grubaa64.efi (dict value)
#pxe_bootfile_name_by_arch =

# Enable iPXE boot. (boolean value)
ipxe_enabled = {{ .Values.config.pxe.ipxe_enabled | default false }}

# On ironic-conductor node, the path to the main iPXE script
# file. (string value)
#ipxe_boot_script = $pybasedir/drivers/modules/boot.ipxe

# Timeout value (in seconds) for downloading an image via
# iPXE. Defaults to 0 (no timeout) (integer value)
#ipxe_timeout = 0

# The IP version that will be used for PXE booting. Defaults
# to 4. EXPERIMENTAL (string value)
# Possible values:
# 4 - IPv4
# 6 - IPv6
#ip_version = 4

# Download deploy and rescue images directly from swift using
# temporary URLs. If set to false (default), images are
# downloaded to the ironic-conductor node and served over its
# local HTTP server. Applicable only when 'ipxe_enabled'
# option is set to true. (boolean value)
#ipxe_use_swift = false


[service_catalog]

#
# From ironic
#

# Authentication URL (string value)
#auth_url = <None>

# Authentication type to load (string value)
# Deprecated group/name - [service_catalog]/auth_plugin
#auth_type = <None>

# PEM encoded Certificate Authority to use when verifying
# HTTPs connections. (string value)
#cafile = <None>

# PEM encoded client certificate cert file (string value)
#certfile = <None>

# Collect per-API call timing information. (boolean value)
#collect_timing = false

# Optional domain ID to use with v3 and v2 parameters. It will
# be used for both the user and project domain in v3 and
# ignored in v2 authentication. (string value)
#default_domain_id = <None>

# Optional domain name to use with v3 API and v2 parameters.
# It will be used for both the user and project domain in v3
# and ignored in v2 authentication. (string value)
#default_domain_name = <None>

# Domain ID to scope to (string value)
#domain_id = <None>

# Domain name to scope to (string value)
#domain_name = <None>

# Always use this endpoint URL for requests for this client.
# NOTE: The unversioned endpoint should be specified here; to
# request a particular API version, use the `version`, `min-
# version`, and/or `max-version` options. (string value)
#endpoint_override = <None>

# Verify HTTPS connections. (boolean value)
#insecure = false

# PEM encoded client certificate key file (string value)
#keyfile = <None>

# The maximum major version of a given API, intended to be
# used as the upper bound of a range with min_version.
# Mutually exclusive with version. (string value)
#max_version = <None>

# The minimum major version of a given API, intended to be
# used as the lower bound of a range with max_version.
# Mutually exclusive with version. If min_version is given
# with no max_version it is as if max version is "latest".
# (string value)
#min_version = <None>

# User's password (string value)
#password = <None>

# Domain ID containing project (string value)
#project_domain_id = <None>

# Domain name containing project (string value)
#project_domain_name = <None>

# Project ID to scope to (string value)
# Deprecated group/name - [service_catalog]/tenant_id
#project_id = <None>

# Project name to scope to (string value)
# Deprecated group/name - [service_catalog]/tenant_name
#project_name = <None>

# The default region_name for endpoint URL discovery. (string
# value)
#region_name = <None>

# The default service_name for endpoint URL discovery. (string
# value)
#service_name = <None>

# The default service_type for endpoint URL discovery. (string
# value)
#service_type = baremetal

# Log requests to multiple loggers. (boolean value)
#split_loggers = false

# Scope for system operations (string value)
#system_scope = <None>

# Tenant ID (string value)
#tenant_id = <None>

# Tenant Name (string value)
#tenant_name = <None>

# Timeout value for http requests (integer value)
#timeout = <None>

# Trust ID (string value)
#trust_id = <None>

# User's domain id (string value)
#user_domain_id = <None>

# User's domain name (string value)
#user_domain_name = <None>

# User id (string value)
#user_id = <None>

# Username (string value)
# Deprecated group/name - [service_catalog]/user_name
#username = <None>

# List of interfaces, in order of preference, for endpoint
# URL. (list value)
#valid_interfaces = internal,public

# Minimum Major API version within a given Major API version
# for endpoint URL discovery. Mutually exclusive with
# min_version and max_version (string value)
#version = <None>


[snmp]

#
# From ironic
#

# Seconds to wait for power action to be completed (integer
# value)
#power_timeout = 10

# Time (in seconds) to sleep between when rebooting (powering
# off and on again) (integer value)
# Minimum value: 0
#reboot_delay = 0

# Response timeout in seconds used for UDP transport. Timeout
# should be a multiple of 0.5 seconds and is applicable to
# each retry. (floating point value)
# Minimum value: 0
#udp_transport_timeout = 1.0

# Maximum number of UDP request retries, 0 means no retries.
# (integer value)
# Minimum value: 0
#udp_transport_retries = 5


[ssl]

#
# From oslo.service.sslutils
#

# CA certificate file to use to verify connecting clients.
# (string value)
# Deprecated group/name - [DEFAULT]/ssl_ca_file
#ca_file = <None>

# Certificate file to use when starting the server securely.
# (string value)
# Deprecated group/name - [DEFAULT]/ssl_cert_file
#cert_file = <None>

# Private key file to use when starting the server securely.
# (string value)
# Deprecated group/name - [DEFAULT]/ssl_key_file
#key_file = <None>

# SSL version to use (valid only if SSL enabled). Valid values
# are TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1, and TLSv1_2 may
# be available on some distributions. (string value)
#version = <None>

# Sets the list of available ciphers. value should be a string
# in the OpenSSL cipher list format. (string value)
#ciphers = <None>


[swift]

#
# From ironic
#

# Authentication URL (string value)
#auth_url = <None>

# Authentication type to load (string value)
# Deprecated group/name - [swift]/auth_plugin
#auth_type = <None>

# PEM encoded Certificate Authority to use when verifying
# HTTPs connections. (string value)
#cafile = <None>

# PEM encoded client certificate cert file (string value)
#certfile = <None>

# Collect per-API call timing information. (boolean value)
#collect_timing = false

# Optional domain ID to use with v3 and v2 parameters. It will
# be used for both the user and project domain in v3 and
# ignored in v2 authentication. (string value)
#default_domain_id = <None>

# Optional domain name to use with v3 API and v2 parameters.
# It will be used for both the user and project domain in v3
# and ignored in v2 authentication. (string value)
#default_domain_name = <None>

# Domain ID to scope to (string value)
#domain_id = <None>

# Domain name to scope to (string value)
#domain_name = <None>

# Always use this endpoint URL for requests for this client.
# NOTE: The unversioned endpoint should be specified here; to
# request a particular API version, use the `version`, `min-
# version`, and/or `max-version` options. (string value)
#endpoint_override = <None>

# Verify HTTPS connections. (boolean value)
#insecure = false

# PEM encoded client certificate key file (string value)
#keyfile = <None>

# The maximum major version of a given API, intended to be
# used as the upper bound of a range with min_version.
# Mutually exclusive with version. (string value)
#max_version = <None>

# The minimum major version of a given API, intended to be
# used as the lower bound of a range with max_version.
# Mutually exclusive with version. If min_version is given
# with no max_version it is as if max version is "latest".
# (string value)
#min_version = <None>

# User's password (string value)
#password = <None>

# Domain ID containing project (string value)
#project_domain_id = <None>

# Domain name containing project (string value)
#project_domain_name = <None>

# Project ID to scope to (string value)
# Deprecated group/name - [swift]/tenant_id
#project_id = <None>

# Project name to scope to (string value)
# Deprecated group/name - [swift]/tenant_name
#project_name = <None>

# The default region_name for endpoint URL discovery. (string
# value)
#region_name = <None>

# The default service_name for endpoint URL discovery. (string
# value)
#service_name = <None>

# The default service_type for endpoint URL discovery. (string
# value)
#service_type = object-store

# Log requests to multiple loggers. (boolean value)
#split_loggers = false

# Maximum number of times to retry a Swift request, before
# failing. (integer value)
#swift_max_retries = 2

# Scope for system operations (string value)
#system_scope = <None>

# Tenant ID (string value)
#tenant_id = <None>

# Tenant Name (string value)
#tenant_name = <None>

# Timeout value for http requests (integer value)
#timeout = <None>

# Trust ID (string value)
#trust_id = <None>

# User's domain id (string value)
#user_domain_id = <None>

# User's domain name (string value)
#user_domain_name = <None>

# User id (string value)
#user_id = <None>

# Username (string value)
# Deprecated group/name - [swift]/user_name
#username = <None>

# List of interfaces, in order of preference, for endpoint
# URL. (list value)
#valid_interfaces = internal,public

# Minimum Major API version within a given Major API version
# for endpoint URL discovery. Mutually exclusive with
# min_version and max_version (string value)
#version = <None>


[xclarity]

#
# From ironic
#

# IP address of the XClarity Controller. Configuration here is
# deprecated and will be removed in the Stein release. Please
# update the driver_info field to use "xclarity_manager_ip"
# instead (string value)
#manager_ip = <None>

# Username for the XClarity Controller. Configuration here is
# deprecated and will be removed in the Stein release. Please
# update the driver_info field to use "xclarity_username"
# instead (string value)
#username = <None>

# Password for XClarity Controller username. Configuration
# here is deprecated and will be removed in the Stein release.
# Please update the driver_info field to use
# "xclarity_password" instead (string value)
#password = <None>

# Port to be used for XClarity Controller connection. (port
# value)
# Minimum value: 0
# Maximum value: 65535
#port = 443
