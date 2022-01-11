#!/bin/bash

IMAGE_NAME=reg.cismet.de/abstract/cids-distribution-tools
IMAGE_VERSION=22.01.1

# RELEASE BUILD ----------------------------------------------------------------
docker build \
  --no-cache \
  -t ${IMAGE_NAME} \
  -t ${IMAGE_NAME}:${IMAGE_VERSION} \
  .
