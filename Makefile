
DOCKERHUB_USER=liamwhite
LATEST_ISTIO_VERSION=0.5.1
ISTIO_REPO_DIR=$(GOPATH)/src/istio.io/istio

SHELL := /bin/bash
ISTIO_INSTALL_DIR=istio-$(LATEST_ISTIO_VERSION)

# Install Istio and Book Info
include install.mk

# Turn components to "dev" mode
include dev.mk

# Build, push and deploy code from your local dev repo
include update.mk

# Watch logs
include watch.mk