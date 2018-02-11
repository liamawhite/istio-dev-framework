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
