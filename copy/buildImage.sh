#!/bin/sh
if [ -z "${CIDS_DISTRIBUTION_DIR}" ]; then DIR=$(dirname $(readlink -f $0)); else DIR=${CIDS_DISTRIBUTION_DIR}; fi
if [ -f "${DIR}/.env" ]; then export $(cat "${DIR}/.env" | grep -v '^#' | xargs); else echo ".env file is missing"; exit 1; fi
# ---

if [ -z "${IMAGE_TAG_PREFIX}" ]; then IMAGE_TAG=${IMAGE_VERSION}; else IMAGE_TAG=${IMAGE_TAG_PREFIX}-${IMAGE_VERSION}; fi

docker build \
  --no-cache \
  --build-arg IMAGE_VERSION=${IMAGE_TAG_PREFIX} \
  -t ${IMAGE_NAME}:${IMAGE_TAG} \
  ${DIR}