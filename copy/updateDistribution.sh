#!/bin/sh
GIT_DISTRIBUTION_RELEASE=$1
if [ -z "${CIDS_DISTRIBUTION_DIR}" ]; then DIR=$(dirname $(readlink -f $0)); else DIR=${CIDS_DISTRIBUTION_DIR}; fi
if [ -z "${GIT_DISTRIBUTION_RELEASE}" ]; then echo "argument for release-version is missing"; exit 1; fi
if [ -f "${DIR}/.env" ]; then export $(cat ${DIR}/.env | grep -v '^#' | xargs); else echo ".env file is missing"; exit 1; fi
#---

if [ -z "${IMAGE_TAG_PREFIX}" ]; then IMAGE_TAG=${IMAGE_VERSION}; else IMAGE_TAG=${IMAGE_TAG_PREFIX}-${IMAGE_VERSION}; fi
IMAGE=${IMAGE_NAME}:${IMAGE_TAG}
CONTAINER_BUILD=build_${CIDS_DISTRIBUTION}_${IMAGE_TAG_PREFIX}_${GIT_DISTRIBUTION_RELEASE}

#----

docker rm -f ${CONTAINER_BUILD} > /dev/null 2>&1

docker run -t \
  --name ${CONTAINER_BUILD} \
  --entrypoint /entrypoint_build.sh \
  --env CIDS_CODEBASE=${CIDS_CODEBASE} \
  --volume ${DIR}/volume/private:/cidsDistribution/.private \
  --volume ${DIR}/volume/local:/cidsDistribution/lib/local${CIDS_EXTENSION} \
  --volume ${DIR}/volume/local:/cidsDistribution/lib/local${CIDS_EXTENSION}Internet \
  ${IMAGE} \
  ${GIT_DISTRIBUTION_RELEASE} \
&& {
  docker commit \
    -a "build.sh" \
    -m "build of branch ${GIT_DISTRIBUTION_RELEASE}" \
    ${CONTAINER_BUILD} \
    ${IMAGE} \
  && { \
    echo "####"
    if [ -z "${GIT_DISTRIBUTION_RELEASE}" ]; then
      echo "# build of ${CIDS_DISTRIBUTION} (dev branch) successful"
    else
      echo "# build of ${CIDS_DISTRIBUTION} (release: ${GIT_DISTRIBUTION_RELEASE}) successful"
      IMAGE_TAG=${IMAGE_TAG_PREFIX}_${GIT_DISTRIBUTION_RELEASE}
      docker tag ${IMAGE} ${IMAGE_NAME}:${IMAGE_TAG}
    fi

    echo "# you can push it to the docker registry with:"
    echo "#    docker push ${IMAGE_NAME}:${IMAGE_TAG}"
    echo "####"
  }
}
docker rm ${CONTAINER_BUILD} > /dev/null 2>&1