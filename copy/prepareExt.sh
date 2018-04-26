#!/bin/sh
IMAGE_TAG=$1
if [ -z "${CIDS_DISTRIBUTION_DIR}" ]; then DIR=$(dirname $(readlink -f $0)); else DIR=${CIDS_DISTRIBUTION_DIR}; fi
if [ -z "${IMAGE_TAG}" ]; then echo "argument for image-tag is missing"; exit 1; fi
if [ -f "${DIR}/.env" ]; then export $(cat $DIR/.env | grep -v '^#' | xargs); else echo ".env file is missing"; exit 1; fi
#---

IMAGE=${IMAGE_NAME}:${IMAGE_TAG}
CONTAINER_EXT=ext_${CIDS_DISTRIBUTION}_${IMAGE_TAG}

#----

docker rm -f ${CONTAINER_EXT} > /dev/null 2>&1
docker run -t \
  --name ${CONTAINER_EXT} \
  --entrypoint /bin/sh \
  --env CIDS_CODEBASE=${CIDS_CODEBASE} \
  --volume ${DIR}/volume/ext/:/cp/ext/ \
  --volume ${DIR}/volume/local:/cidsDistribution/lib/local${CIDS_EXTENSION} \
  --volume ${DIR}/volume/local:/cidsDistribution/lib/local${CIDS_EXTENSION}Internet \
  ${IMAGE} \
  -c 'cp -v /cp/ext/*.jar /cidsDistribution/lib/ext/'

docker rm -f ${CONTAINER_EXT} > /dev/null 2>&1