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
	cp $(ISTIO_REPO_DIR)/tools/deb/envoy_bootstrap_tmpl.json $(ISTIO_REPO_DIR)/pilot/docker
	cd $(ISTIO_REPO_DIR)/pilot/docker && docker build --no-cache -t docker.io/$(DOCKERHUB_USER)/proxy_debug:dev -f Dockerfile.proxy_debug .
	docker push docker.io/$(DOCKERHUB_USER)/proxy_debug:dev

update-pilot-image:
	-cd $(ISTIO_REPO_DIR) && rm pilot/docker/pilot-discovery
	cd $(ISTIO_REPO_DIR) && GOOS=linux GOARCH=amd64 go build -o pilot/docker/pilot-discovery ./pilot/cmd/pilot-discovery
	cd $(ISTIO_REPO_DIR)/pilot/docker && docker build --no-cache -t docker.io/$(DOCKERHUB_USER)/pilot:dev -f Dockerfile.pilot .
	docker push docker.io/$(DOCKERHUB_USER)/pilot:dev
