
DOCKERHUB_USER=liamwhite
GCLOUD_ACCOUNT?=liam@tetrate.io 

SHELL := /bin/bash
ISTIO_DIR=$(GOPATH)/src/istio.io
ISTIO_MASTER_DIR=$(ISTIO_DIR)/istio
RELEASES_DIR=$(ISTIO_DIR)/releases
LATEST_RELEASE_DIR=$(RELEASES_DIR)/$$(ls -t ${RELEASES_DIR} | grep -v snapshot | sort -r | head -1)
LATEST_SNAPSHOT_DIR=$(RELEASES_DIR)/$$(ls -t ${RELEASES_DIR} | grep snapshot | sort -r | head -1)

# Install Istio and Book Info
include install.mk

# Build, push and deploy code from your local dev repo
include update.mk
