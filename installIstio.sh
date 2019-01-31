#! /bin/bash

ISTIO_DIR=$1
PROXY_IMAGE=$2

kubectl apply -f $ISTIO_DIR/install/kubernetes/namespace.yaml
helm template $ISTIO_DIR/install/kubernetes/helm/istio-init --name istio --namespace istio-system --set global.imagePullPolicy=Always | kubectl apply --as=admin --as-group=system:masters -f -
rm $ISTIO_DIR/install/kubernetes/helm/istio/requirements.lock
helm repo add istio.io "https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts"
helm dep build $ISTIO_DIR/install/kubernetes/helm/istio
echo "Sleeping for 10s to ensure CRDs are installed..."
sleep 10
echo "Installing Istio..."
if [ -n "$PROXY_IMAGE" ];
then
    echo "Setting Proxy Image to $PROXY_IMAGE"
    helm template $ISTIO_DIR/install/kubernetes/helm/istio --name istio --namespace istio-system --set global.imagePullPolicy=Always --set tracing.enabled=true --set global.proxy.image=$PROXY_IMAGE | kubectl apply --as=admin --as-group=system:masters -f -
else
    helm template $ISTIO_DIR/install/kubernetes/helm/istio --name istio --namespace istio-system --set global.imagePullPolicy=Always --set tracing.enabled=true | kubectl apply --as=admin --as-group=system:masters -f -
fi
