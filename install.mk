# Install Istio and BookInfo

install.istio.master:
	./installIstio.sh $(ISTIO_MASTER_DIR) docker.io/$(DOCKERHUB_USER)/proxyv2:dev

install.istio.release:
	# -kubectl create namespace istio-system
	# echo $(LATEST_RELEASE_DIR)

install.istio.snapshot:
	./installIstio.sh $(LATEST_SNAPSHOT_DIR)

retrieve.istio.release:
	cd $(RELEASES_DIR) && curl -L https://git.io/getLatestIstio | sh -

retrieve.istio.snapshot:
	./getLatestSnapshot.sh

install.bookinfo:
	-kubectl label namespace default istio-injection=enabled --overwrite
	cat $(ISTIO_MASTER_DIR)/samples/bookinfo/platform/kube/bookinfo.yaml | sed 's/imagePullPolicy: IfNotPresent/imagePullPolicy: Always/g' | kubectl apply -f -
	kubectl apply -f $(ISTIO_MASTER_DIR)/samples/bookinfo/networking/bookinfo-gateway.yaml

reset.istio.master: delete.istio install.istio.master install.bookinfo update.all
reset.istio.snapshot: delete.istio install.istio.snapshot install.bookinfo

reset.infra.istio.master: reset.infra install.istio.master install.bookinfo
reset.infra.istio.snapshot: reset.infra install.istio.snapshot install.bookinfo

reset.infra:
	infra/destroy
	infra/provision
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user ${GCLOUD_ACCOUNT}

delete.istio:
	-kubectl delete $$(kubectl get crds -o name | grep istio)
	-kubectl delete $$(kubectl get clusterrole -o name | grep istio)
	-kubectl delete $$(kubectl get clusterrolebinding -o name | grep istio)
	-kubectl delete $$(kubectl get mutatingwebhookconfiguration -o name | grep istio)
	-kubectl delete namespace istio-system
