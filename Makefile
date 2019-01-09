
DOCKERHUB_USER=liamwhite

SHELL := /bin/bash
ISTIO_DIR=$(GOPATH)/src/istio.io/istio

# Install Istio and Book Info
include install.mk

# Build, push and deploy code from your local dev repo
include update.mk
