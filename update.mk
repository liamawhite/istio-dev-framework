# Build, push and deploy code from your local dev repo

#####################################################
######################  PROXY  ######################
#####################################################

image.proxy:
	-rm $(GOPATH)/out/linux_amd64/release/docker_build/docker.proxyv2/pilot-agent $(GOPATH)/out/linux_amd64/release/pilot-agent
	cd $(ISTIO_DIR) && GOOS=linux GOARCH=amd64 make pilot-agent
	cd $(ISTIO_DIR) && GOOS=linux GOARCH=amd64 make push.docker.proxyv2

patch.proxy.bookinfo:
	kubectl patch $$(kubectl get pods -o name) -p '{"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxyv2:dev"}]}}'

delete.proxy.bookinfo:
	kubectl delete $$(kubectl get pods -o name)

update.proxy.bookinfo: image.proxy delete.proxy.bookinfo patch.proxy.bookinfo

#####################################################
######################  PILOT  ######################
#####################################################

image.pilot:
	-rm $(GOPATH)/out/linux_amd64/release/docker_build/docker.proxyv2/pilot-dicovery $(GOPATH)/out/linux_amd64/release/pilot-discovery
	cd $(ISTIO_DIR) && GOOS=linux GOARCH=amd64 make pilot-discovery
	cd $(ISTIO_DIR) && GOOS=linux GOARCH=amd64 make push.docker.pilot

patch.pilot:
	kubectl patch -n istio-system $$(kubectl get pods -n istio-system -l istio=pilot -o name) -p '{"spec": {"containers": [{"name": "discovery", "image": "docker.io/$(DOCKERHUB_USER)/pilot:dev"}]}}'

delete.pilot:
	kubectl delete $$(kubectl get pods -n istio-system -l istio=pilot -o name)

update.pilot: image.pilot delete.pilot patch.pilot
