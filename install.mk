# Install Istio and BookInfo

install.istio:
	-kubectl create namespace istio-system
	helm template --name istio --namespace istio-system $(ISTIO_DIR)/install/kubernetes/helm/istio --set global.imagePullPolicy=Always | kubectl apply --as=admin --as-group=system:masters -f -

install.bookinfo:
	-kubectl label namespace default istio-injection=enabled
	kubectl apply -f $(ISTIO_DIR)/samples/bookinfo/platform/kube/bookinfo.yaml
