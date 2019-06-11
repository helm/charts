#!/usr/bin/env bash

HELM_RELEASE_NAME=prom-op
CHART=./
NAMESPACE=monitoring
VALUES_FILES=./hack/minikube/values.yaml

if [ "$1" = "reset-minikube" ]; then
  minikube delete
  minikube start  \
    #--vm-driver hyperv --hyperv-virtual-switch "Default Switch" \
    --kubernetes-version=v1.13.3 \
    --memory=4096 --bootstrapper=kubeadm \
    --extra-config=kubelet.authentication-token-webhook=true \
    --extra-config=kubelet.authorization-mode=Webhook \
    --extra-config=scheduler.address=0.0.0.0 \
    --extra-config=controller-manager.address=0.0.0.0
  exit 0
fi

if [ "$1" = "init-helm" ]; then
  helm init
  helm repo update
  exit 0
fi

if [ "$1" = "init-etcd-secret" ]; then
  kubectl create namespace monitoring
  kubectl delete secret etcd-certs -nmonitoring
  kubectl create secret generic etcd-certs -nmonitoring \
  --from-literal=ca.crt="$(kubectl exec kube-apiserver-minikube -nkube-system -- cat /var/lib/minikube/certs/etcd/ca.crt)" \
  --from-literal=client.crt="$(kubectl exec kube-apiserver-minikube -nkube-system -- cat /var/lib/minikube/certs/apiserver-etcd-client.crt)" \
  --from-literal=client.key="$(kubectl exec kube-apiserver-minikube -nkube-system -- cat /var/lib/minikube/certs/apiserver-etcd-client.key)"

  exit 0
fi


if [ "$1" = "prometheus-operator" ]; then
  helm upgrade $HELM_RELEASE_NAME $CHART \
    --namespace $NAMESPACE     \
    --values    $VALUES_FILES  \
    --set       grafana.podAnnotations.redeploy-hack="$(cat /proc/sys/kernel/random/uuid)" \
    --install --debug
  exit 0
fi

if [ "$1" = "port-forward" ]; then
  killall kubectl &>/dev/null
  kubectl port-forward service/prom-op-prometheus-operato-prometheus 9090 &>/dev/null &
  kubectl port-forward service/prom-op-prometheus-operato-alertmanager 9093 &>/dev/null &
  kubectl port-forward service/prom-op-grafana 3000:80 &>/dev/null &
  echo "Started port-forward commands"
  echo "localhost:9090 - prometheus"
  echo "localhost:9093 - alertmanager"
  echo "localhost:3000 - grafana"
  exit 0
fi

cat << EOF
Usage:
  install.sh <COMMAND>

Commands:
  reset-minikube      - resets minikube with values suitable for running prometheus operator
                        the normal installation will not allow scraping of the kubelet,
                        scheduler or controller-manager components
  init-helm           - initialize helm and update repository so that we can install
                        the prometheus-operator chart. This has to be run only once after
                        a minikube installation is done
  init-etcd-secret    - pulls the certs used to access etcd from the api server and creates
                        a secret in the monitoring namespace with them. The values files
                        in the install command assume that this secret exists and is valid.
                        If not, then prometheus will not start
  prometheus-operator - install or upgrade the prometheus operator chart in the cluster
  port-forward        - starts port-forwarding for prometheus, alertmanager, grafana
                        localhost:9090 - prometheus
                        localhost:9093 - alertmanager
                        localhost:3000 - grafana
EOF

exit 0
}

