{{/* vim: set filetype=mustache: */}}

{{- define "config-redis.conf" }}
{{- if .Values.redis.customConfig }}
{{ tpl .Values.redis.customConfig . | indent 4 }}
{{- else }}
    dir "/data"
    port {{ .Values.redis.port }}
    {{- range $key, $value := .Values.redis.config }}
    {{ $key }} {{ $value }}
    {{- end }}
{{- if .Values.auth }}
    requirepass replace-default-auth
    masterauth replace-default-auth
{{- end }}
{{- end }}
{{- end }}

{{- define "config-sentinel.conf" }}
{{- if .Values.sentinel.customConfig }}
{{ tpl .Values.sentinel.customConfig . | indent 4 }}
{{- else }}
    dir "/data"
    {{- range $key, $value := .Values.sentinel.config }}
    sentinel {{ $key }} {{ template "redis-ha.masterGroupName" $ }} {{ $value }}
    {{- end }}
{{- if .Values.auth }}
    sentinel auth-pass {{ template "redis-ha.masterGroupName" . }} replace-default-auth
{{- end }}
{{- end }}
{{- end }}

{{- define "config-init.sh" }}
    HOSTNAME="$(hostname)"
    INDEX="${HOSTNAME##*-}"
    MASTER="$(redis-cli -h {{ template "redis-ha.fullname" . }} -p {{ .Values.sentinel.port }} sentinel get-master-addr-by-name {{ template "redis-ha.masterGroupName" . }} | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
    MASTER_GROUP="{{ template "redis-ha.masterGroupName" . }}"
    QUORUM="{{ .Values.sentinel.quorum }}"
    REDIS_CONF=/data/conf/redis.conf
    REDIS_PORT={{ .Values.redis.port }}
    SENTINEL_CONF=/data/conf/sentinel.conf
    SENTINEL_PORT={{ .Values.sentinel.port }}
    SERVICE={{ template "redis-ha.fullname" . }}
    set -eu

    sentinel_update() {
        echo "Updating sentinel config with master $MASTER"
        eval MY_SENTINEL_ID="\${SENTINEL_ID_$INDEX}"
        sed -i "1s/^/sentinel myid $MY_SENTINEL_ID\\n/" "$SENTINEL_CONF"
        sed -i "2s/^/sentinel monitor $MASTER_GROUP $1 $REDIS_PORT $QUORUM \\n/" "$SENTINEL_CONF"
        echo "sentinel announce-ip $ANNOUNCE_IP" >> $SENTINEL_CONF
        echo "sentinel announce-port $SENTINEL_PORT" >> $SENTINEL_CONF
    }

    redis_update() {
        echo "Updating redis config"
        echo "slaveof $1 $REDIS_PORT" >> "$REDIS_CONF"
        echo "slave-announce-ip $ANNOUNCE_IP" >> $REDIS_CONF
        echo "slave-announce-port $REDIS_PORT" >> $REDIS_CONF
    }

    copy_config() {
        cp /readonly-config/redis.conf "$REDIS_CONF"
        cp /readonly-config/sentinel.conf "$SENTINEL_CONF"
    }

    setup_defaults() {
        echo "Setting up defaults"
        if [ "$INDEX" = "0" ]; then
            echo "Setting this pod as the default master"
            redis_update "$ANNOUNCE_IP"
            sentinel_update "$ANNOUNCE_IP"
            sed -i "s/^.*slaveof.*//" "$REDIS_CONF"
        else
            DEFAULT_MASTER="$(getent hosts "$SERVICE-announce-0" | awk '{ print $1 }')"
            if [ -z "$DEFAULT_MASTER" ]; then
                echo "Unable to resolve host"
                exit 1
            fi
            echo "Setting default slave config.."
            redis_update "$DEFAULT_MASTER"
            sentinel_update "$DEFAULT_MASTER"
        fi
    }

    find_master() {
        echo "Attempting to find master"
        if [ "$(redis-cli -h "$MASTER"{{ if .Values.auth }} -a "$AUTH"{{ end }} ping)" != "PONG" ]; then
           echo "Can't ping master, attempting to force failover"
           if redis-cli -h "$SERVICE" -p "$SENTINEL_PORT" sentinel failover "$MASTER_GROUP" | grep -q 'NOGOODSLAVE' ; then
               setup_defaults
               return 0
           fi
           sleep 10
           MASTER="$(redis-cli -h $SERVICE -p $SENTINEL_PORT sentinel get-master-addr-by-name $MASTER_GROUP | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
           if [ "$MASTER" ]; then
               sentinel_update "$MASTER"
               redis_update "$MASTER"
           else
              echo "Could not failover, exiting..."
              exit 1
           fi
        else
            echo "Found reachable master, updating config"
            sentinel_update "$MASTER"
            redis_update "$MASTER"
        fi
    }

    mkdir -p /data/conf/

    echo "Initializing config.."
    copy_config

    ANNOUNCE_IP=$(getent hosts "$SERVICE-announce-$INDEX" | awk '{ print $1 }')
    if [ -z "$ANNOUNCE_IP" ]; then
        "Could not resolve the announce ip for this pod"
        exit 1
    elif [ "$MASTER" ]; then
        find_master
    else
        setup_defaults
    fi

    if [ "${AUTH:-}" ]; then
        echo "Setting auth values"
        ESCAPED_AUTH=$(echo "$AUTH" | sed -e 's/[\/&]/\\&/g');
        sed -i "s/replace-default-auth/${ESCAPED_AUTH}/" "$REDIS_CONF" "$SENTINEL_CONF"
    fi

    echo "Ready..."
{{- end }}

{{- define "config-haproxy.cfg" }}
{{- if .Values.haproxy.customConfig }}
{{ .Values.haproxy.customConfig | indent 4}}
{{- else }}
    defaults REDIS
      mode tcp
      timeout connect {{ .Values.haproxy.timeout.connect }}
      timeout server {{ .Values.haproxy.timeout.server }}
      timeout client {{ .Values.haproxy.timeout.client }}
      timeout check {{ .Values.haproxy.timeout.check }}

    listen health_check_http_url
      bind :8888
      mode http
      monitor-uri /healthz
      option      dontlognull

    {{- $root := . }}
    {{- $fullName := include "redis-ha.fullname" . }}
    {{- $replicas := int (toString .Values.replicas) }}
    {{- $masterGroupName := include "redis-ha.masterGroupName" . }}
    {{- range $i := until $replicas }}
    # Check Sentinel and whether they are nominated master
    backend check_if_redis_is_master_{{ $i }}
      mode tcp
      option tcp-check
      tcp-check connect
      {{- if $root.auth }}
      tcp-check send AUTH\ {{ $root.redisPassword }}\r\n
      tcp-check expect string +OK
      {{- end }}
      tcp-check send PING\r\n
      tcp-check expect string +PONG
      tcp-check send SENTINEL\ get-master-addr-by-name\ {{ $masterGroupName }}\r\n
      tcp-check expect string REPLACE_ANNOUNCE{{ $i }}
      tcp-check send QUIT\r\n
      tcp-check expect string +OK
      {{- range $i := until $replicas }}
      server R{{ $i }} {{ $fullName }}-announce-{{ $i }}:26379 check inter 1s
      {{- end }}
    {{- end }}

    # decide redis backend to use
    #master
    frontend ft_redis_master
      bind *:{{ $root.Values.redis.port }}
      use_backend bk_redis_master
    {{- if .Values.haproxy.readOnly.enabled }}
    #slave
    frontend ft_redis_slave
      bind *:{{ .Values.haproxy.readOnly.port }}
      use_backend bk_redis_slave
    {{- end }}
    # Check all redis servers to see if they think they are master
    backend bk_redis_master
      {{- if .Values.haproxy.stickyBalancing }}
      balance source
      hash-type consistent
      {{- end }}
      mode tcp
      option tcp-check
      tcp-check connect
      {{- if .Values.auth }}
      tcp-check send AUTH\ REPLACE_AUTH_SECRET\r\n
      tcp-check expect string +OK
      {{- end }}
      tcp-check send PING\r\n
      tcp-check expect string +PONG
      tcp-check send info\ replication\r\n
      tcp-check expect string role:master
      tcp-check send QUIT\r\n
      tcp-check expect string +OK
      {{- range $i := until $replicas }}
      use-server R{{ $i }} if { srv_is_up(R{{ $i }}) } { nbsrv(check_if_redis_is_master_{{ $i }}) ge 2 }
      server R{{ $i }} {{ $fullName }}-announce-{{ $i }}:{{ $root.Values.redis.port }} check inter 1s fall 1 rise 1
      {{- end }}
    {{- if .Values.haproxy.readOnly.enabled }}
    backend bk_redis_slave
      {{- if .Values.haproxy.stickyBalancing }}
      balance source
      hash-type consistent
      {{- end }}
      mode tcp
      option tcp-check
      tcp-check connect
      {{- if .Values.auth }}
      tcp-check send AUTH\ REPLACE_AUTH_SECRET\r\n
      tcp-check expect string +OK
      {{- end }}
      tcp-check send PING\r\n
      tcp-check expect string +PONG
      tcp-check send info\ replication\r\n
      tcp-check expect  string role:slave
      tcp-check send QUIT\r\n
      tcp-check expect string +OK
      {{- range $i := until $replicas }}
      server R{{ $i }} {{ $fullName }}-announce-{{ $i }}:{{ $root.Values.redis.port }} check inter 1s fall 1 rise 1
      {{- end }}
    {{- end }}
    {{- if .Values.haproxy.metrics.enabled }}
    frontend metrics
      mode http
      bind *:{{ .Values.haproxy.metrics.port }}
      option http-use-htx
      http-request use-service prometheus-exporter if { path {{ .Values.haproxy.metrics.scrapePath }} }
    {{- end }}
{{- if .Values.haproxy.extraConfig }}
    # Additional configuration
{{ .Values.haproxy.extraConfig | indent 4 }}
{{- end }}
{{- end }}
{{- end }}


{{- define "config-haproxy_init.sh" }}
    HAPROXY_CONF=/data/haproxy.cfg
    cp /readonly/haproxy.cfg "$HAPROXY_CONF"
    {{- $fullName := include "redis-ha.fullname" . }}
    {{- $replicas := int (toString .Values.replicas) }}
    {{- range $i := until $replicas }}
    for loop in $(seq 1 10); do
      getent hosts {{ $fullName }}-announce-{{ $i }} && break
      echo "Waiting for service {{ $fullName }}-announce-{{ $i }} to be ready ($loop) ..." && sleep 1
    done
    ANNOUNCE_IP{{ $i }}=$(getent hosts "{{ $fullName }}-announce-{{ $i }}" | awk '{ print $1 }')
    if [ -z "$ANNOUNCE_IP{{ $i }}" ]; then
      echo "Could not resolve the announce ip for {{ $fullName }}-announce-{{ $i }}"
      exit 1
    fi
    sed -i "s/REPLACE_ANNOUNCE{{ $i }}/$ANNOUNCE_IP{{ $i }}/" "$HAPROXY_CONF"

    if [ "${AUTH:-}" ]; then
        echo "Setting auth values"
        ESCAPED_AUTH=$(echo "$AUTH" | sed -e 's/[\/&]/\\&/g');
        sed -i "s/REPLACE_AUTH_SECRET/${ESCAPED_AUTH}/" "$HAPROXY_CONF"
    fi
    {{- end }}
{{- end }}
