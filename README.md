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

## Installing Istio/Book Info

This will install Istio without mTLS.

```
make install-istio
make install-bookinfo
```

## Development Flow

Turn on dev mode for the component you are working on. These will fail to re-deploy the microservice initially as you won't have the relevant images in your DockerHub repo.

```
make dev-pilot
make dev-pilot-proxy
make dev-bookinfo-proxy
```

When you want to test your code in kube run an update command. This builds the go binary and Dockerfile, pushes it to your DockerHub repo and then deletes the pod to force a pull of the image and re-deploy.

```
make update-pilot
make update-bookinfo-proxy
make update-pilot-proxy
```

### Optional:

Tail logs of the thing you are developing.
```
make watch-pilot
make watch-pilot-proxy
make watch-details-proxy
```
