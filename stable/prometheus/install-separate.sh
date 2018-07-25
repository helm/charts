#!/bin/sh

values='alertmanager.enabled=false,kubeStateMetrics.enabled=false,nodeExporter.enabled=false,pushgateway.enabled=false,server.enabled=false'
deployset='alertmanager kubeStateMetrics nodeExporter pushgateway server'

if [ -n "$1" ] ; then
  deployset="$*"
fi

for app in $deployset ; do
  lower="$(echo "$app" | tr A-Z a-z)"
  helm upgrade \
    --namespace=$lower \
    --install p-$lower \
    . \
    --set "$(echo "$values" | sed "s/$app.enabled=false/$app.enabled=true/")" \
    --set "$app.ingress.extraLabels.traefik=exposed" \
    --set "$app.ingress.enabled=true" \
    --set "$app.ingress.hosts[0]=$app"
done
