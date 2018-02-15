# Install Istio and Book Info
.PHONY: install install-istio install-istio-auth install-bookinfo uninstall uninstall-istio uninstall-bookinfo

install: install-istio install-bookinfo

get-istio:
	curl -L https://git.io/getLatestIstio | sh -

install-istio:
	kubectl apply -f $(ISTIO_INSTALL_DIR)/install/kubernetes/istio.yaml

install-istio-auth:
	kubectl apply -f $(ISTIO_INSTALL_DIR)/install/kubernetes/istio-auth.yaml

install-bookinfo:
	kubectl apply -f <(istioctl kube-inject -f $(ISTIO_INSTALL_DIR)/samples/bookinfo/kube/bookinfo.yaml)

uninstall-istio:
	-kubectl delete -f $(ISTIO_INSTALL_DIR)/install/kubernetes/istio.yaml

uninstall-bookinfo:
	-kubectl delete -f $(ISTIO_INSTALL_DIR)/samples/bookinfo/kube/bookinfo.yaml

uninstall: uninstall-bookinfo uninstall-istio