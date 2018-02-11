
DOCKERHUB_USER=liamwhite
LATEST_ISTIO_VERSION=0.5.0
ISTIO_REPO_DIR=$(GOPATH)/src/istio.io/istio

SHELL := /bin/bash
ISTIO_INSTALL_DIR=istio-$(LATEST_ISTIO_VERSION)



# Install Istio and Book Info
.PHONY: install install-istio install-bookinfo uninstall uninstall-istio uninstall-bookinfo

install: install-istio install-bookinfo

get-istio:
	curl -L https://git.io/getLatestIstio | sh -

install-istio:
	kubectl apply -f $(ISTIO_INSTALL_DIR)/install/kubernetes/istio.yaml

install-bookinfo:
	kubectl apply -f <(istioctl kube-inject -f $(ISTIO_INSTALL_DIR)/samples/bookinfo/kube/bookinfo.yaml)

uninstall-istio:
	-kubectl delete -f $(ISTIO_INSTALL_DIR)/install/kubernetes/istio.yaml

uninstall-bookinfo:
	-kubectl delete -f $(ISTIO_INSTALL_DIR)/samples/bookinfo/kube/bookinfo.yaml

uninstall: uninstall-bookinfo uninstall-istio



# Turn on components to "dev" mode
.PHONY: pilot-dev pilot-agent-dev bookinfo-agent-dev

pilot-dev:
	kubectl patch -n istio-system deployment istio-pilot -p '{"spec": {"template": {"spec": {"containers": [{"name": "discovery", "image": "docker.io/$(DOCKERHUB_USER)/pilot:dev", "imagePullPolicy": "Always"}]}}}}'

pilot-agent-dev:
	kubectl patch -n istio-system deployment istio-pilot -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'

bookinfo-agent-dev:
	kubectl patch deployment details-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment productpage-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment ratings-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment reviews-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment reviews-v2 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment reviews-v3 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'



# Build, push and deploy code from your local dev repo
.PHONY: update-pilot update-bookinfo-proxy update-pilot-proxy

update-pilot: update-pilot-image
	kubectl delete pod -n istio-system $$(kubectl get pod -n istio-system -l istio=pilot -o jsonpath='{.items[0].metadata.name}')

update-bookinfo-proxy: update-proxy-image
	kubectl delete pods --all

update-pilot-proxy: update-proxy-image
	kubectl delete pod -n istio-system $$(kubectl get pod -n istio-system -l istio=pilot -o jsonpath='{.items[0].metadata.name}')

update-proxy-image:
	-cd $(ISTIO_REPO_DIR) && rm pilot/docker/pilot-agent
	cd $(ISTIO_REPO_DIR) && GOOS=linux GOARCH=amd64 go build -o pilot/docker/pilot-agent ./pilot/cmd/pilot-agent
	cd $(ISTIO_REPO_DIR)/pilot/docker && docker build --no-cache -t docker.io/$(DOCKERHUB_USER)/proxy_debug:dev -f Dockerfile.proxy_debug .
	docker push docker.io/$(DOCKERHUB_USER)/proxy_debug:dev

update-pilot-image:
	-cd $(ISTIO_REPO_DIR) && rm pilot/docker/pilot-discovery
	cd $(ISTIO_REPO_DIR) && GOOS=linux GOARCH=amd64 go build -o pilot/docker/pilot-discovery ./pilot/cmd/pilot-discovery
	cd $(ISTIO_REPO_DIR)/pilot/docker && docker build --no-cache -t docker.io/$(DOCKERHUB_USER)/pilot:dev -f Dockerfile.pilot .
	docker push docker.io/$(DOCKERHUB_USER)/pilot:dev



# Watch logs
.PHONY: watch-pilot watch-pilot-proxy watch-details-proxy

watch-pilot:
	kubectl logs -n istio-system $$(kubectl get pod -n istio-system -l istio=pilot -o jsonpath='{.items[0].metadata.name}') -f discovery

watch-pilot-proxy:
	kubectl logs -n istio-system $$(kubectl get pod -n istio-system -l istio=pilot -o jsonpath='{.items[0].metadata.name}') -f istio-proxy

watch-details-proxy:
	kubectl logs $$(kubectl get pod -l app=details -o jsonpath='{.items[0].metadata.name}') -f istio-proxy

