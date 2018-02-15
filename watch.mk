# Watch logs
.PHONY: watch-pilot watch-pilot-proxy watch-details-proxy

watch-pilot:
	kubectl logs -n istio-system $$(kubectl get pod -n istio-system -l istio=pilot -o jsonpath='{.items[0].metadata.name}') -f discovery

watch-pilot-proxy:
	kubectl logs -n istio-system $$(kubectl get pod -n istio-system -l istio=pilot -o jsonpath='{.items[0].metadata.name}') -f istio-proxy

watch-details-proxy:
	kubectl logs $$(kubectl get pod -l app=details -o jsonpath='{.items[0].metadata.name}') -f istio-proxy