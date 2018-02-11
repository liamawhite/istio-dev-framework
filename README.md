# Istio Development Framework

This repo allows an Istio developer to quickly run code in their local Istio repo in a Kube cluster during development.

Currently, functionality is limited to Pilot and proxy agents of Pilot/Bookinfo but PRs are welcome!

## Prerequisites

The following prerequisites must be matched before the make commands will work:
- You must be logged in to your account on Dockerhub
- You must have kubectl set up to talk to your Kube cluster

## Setup

Set the following variables in the `Makefile`:
```
DOCKERHUB_USER=<your-dockerhub-username>
LATEST_ISTIO_VERSION=0.5.0
ISTIO_REPO_DIR=$(GOPATH)/src/istio.io/istio
```

>**Note**: You probably won't have to change the second two variables.

Pull in the latest Istio installation helpers
```
make get-istio
```

## Bugs

There is currently some hacking that needs to be done in order to build the proxy image. You will need to comment out [this](https://github.com/istio/istio/blob/master/Makefile#L482) and [this](https://github.com/istio/istio/blob/master/Makefile#L486) line and run `make docker.proxy_debug` in your Istio repository then copy the generated `envoy_bootstrap_tmpl.json` to `<Istio-Repo-Dir>/pilot/docker`

Ideally, this will be fixed when Istio fixes `make docker` commands to be runnable on non-Linux systems and we can just call those commands directly.
