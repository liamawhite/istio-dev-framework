# Turn components to "dev" mode
.PHONY: dev-pilot dev-pilot-agent dev-bookinfo-agent

dev-pilot:
	kubectl patch -n istio-system deployment istio-pilot -p '{"spec": {"template": {"spec": {"containers": [{"name": "discovery", "image": "docker.io/$(DOCKERHUB_USER)/pilot:dev", "imagePullPolicy": "Always"}]}}}}'

dev-pilot-proxy:
	kubectl patch -n istio-system deployment istio-pilot -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'

dev-bookinfo-proxy:
	kubectl patch deployment details-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment productpage-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment ratings-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment reviews-v1 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment reviews-v2 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'
	kubectl patch deployment reviews-v3 -p '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy", "image": "docker.io/$(DOCKERHUB_USER)/proxy_debug:dev", "imagePullPolicy": "Always"}]}}}}'


