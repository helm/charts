# Push some helpful vars into labels
PODIP=`hostname -i`
echo podIP $PODIP
kubectl label --overwrite pod $HOSTNAME podIP="$PODIP"

if [ "$SENTINEL" ]; then
    exit
fi

RUNID=""

# Only sets AUTH if the ENV var REDIS_PASS is set.
REDISAUTH=""
[ -n "$REDIS_PASS" ] && REDISAUTH="-a $REDIS_PASS" || REDISAUTH=""

while true; do
  RUNID=`redis-cli $REDISAUTH info server |grep run_id|awk -F: '{print $2}'|head -c6`
  if [ -n "$RUNID" ]; then
    kubectl label --overwrite pod $HOSTNAME runID="$RUNID"
    break
  else
    sleep 1
  fi
done
