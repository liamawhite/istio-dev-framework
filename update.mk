# Build, push and deploy code from your local dev repo

update.all: update.galley update.pilot update.mixer update.proxy.bookinfo 

#####################################################
######################  PROXY  ######################
#####################################################

image.proxy:
	-rm $(GOPATH)/out/linux_amd64/release/docker_build/docker.proxyv2/pilot-agent $(GOPATH)/out/linux_amd64/release/pilot-agent
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make pilot-agent
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make push.docker.proxyv2

delete.proxy.bookinfo:
	kubectl delete $$(kubectl get pods -o name)

delete.proxy.ingress:
	time kubectl delete -n istio-system $$(kubectl get pods -o name -n istio-system | grep ingress)

update.proxy.bookinfo: image.proxy delete.proxy.bookinfo
update.proxy.ingress: image.proxy delete.proxy.ingress

#####################################################
######################  PILOT  ######################
#####################################################

image.pilot:
	-rm $(GOPATH)/out/linux_amd64/release/docker_build/docker.pilot/pilot-dicovery $(GOPATH)/out/linux_amd64/release/pilot-discovery
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make pilot-discovery
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make push.docker.pilot

patch.pilot:
	kubectl patch -n istio-system $$(kubectl get deploy -n istio-system -l istio=pilot -o name) -p '{"spec": {"template": {"spec": {"containers": [{"name": "discovery", "image": "docker.io/$(DOCKERHUB_USER)/pilot:dev"}]}}}}'
	kubectl patch -n istio-system $$(kubectl get deploy -n istio-system -l istio=pilot -o name) -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxyv2:dev"}]}}}}'

delete.pilot:
	kubectl delete -n istio-system $$(kubectl get pods -n istio-system -l istio=pilot -o name)

update.pilot: image.pilot delete.pilot patch.pilot

#####################################################
######################  GALLEY  #####################
#####################################################

image.galley:
	-rm $(GOPATH)/out/linux_amd64/release/docker_build/docker.galley/galley $(GOPATH)/out/linux_amd64/release/galley
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make galley
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make push.docker.galley

patch.galley:
	kubectl patch -n istio-system $$(kubectl get deploy -n istio-system -l istio=galley -o name) -p '{"spec": {"template": {"spec": {"containers": [{"name": "galley", "image": "docker.io/$(DOCKERHUB_USER)/galley:dev"}]}}}}'

delete.galley:
	kubectl delete -n istio-system $$(kubectl get pods -n istio-system -l istio=galley -o name)

update.galley: image.galley delete.galley patch.galley

#####################################################
######################  MIXER  ######################
#####################################################

image.mixer:
	-rm $(GOPATH)/out/linux_amd64/release/docker_build/docker.mixer/mixs $(GOPATH)/out/linux_amd64/release/mixs
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make mixs
	cd $(ISTIO_MASTER_DIR) && GOOS=linux GOARCH=amd64 make push.docker.mixer

patch.mixer:
	kubectl patch -n istio-system $$(kubectl get deploy -n istio-system -l istio=mixer -o name) -p '{"spec": {"template": {"spec": {"containers": [{"name": "mixer", "image": "docker.io/$(DOCKERHUB_USER)/mixer:dev"}]}}}}'

delete.mixer:
	kubectl delete -n istio-system $$(kubectl get pods -n istio-system -l istio=mixer -o name)

update.mixer: image.mixer delete.mixer patch.mixer
