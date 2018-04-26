#!/bin/sh
if [ -z "${CIDS_DISTRIBUTION_DIR}" ]; then DIR=$(dirname $(readlink -f $0)); else DIR=${CIDS_DISTRIBUTION_DIR}; fi
if [ -f "${DIR}/.env" ]; then export $(cat "${DIR}/.env" | grep -v '^#' | xargs); else echo ".env file is missing"; exit 1; fi
# ---

IMAGE_TAG=${IMAGE_TAG_PREFIX}_${IMAGE_VERSION}

docker build \
  --no-cache \
  --build-arg IMAGE_VERSION=${IMAGE_TAG_PREFIX} \
  -t ${IMAGE_NAME}:${IMAGE_VERSION} \
  ${DIR}