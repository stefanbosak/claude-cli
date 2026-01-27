#!/bin/bash

# start Docker build
export DOCKER_BUILDKIT_ATTESTATIONS=0

# default target OS, architecture and platforms
export TARGETOS=${TARGETOS:-linux}

if [ -f "/etc/debian_version" ]; then
  export TARGETARCH=${TARGETARCH:-$(dpkg --print-architecture)}
else
  export TARGETARCH=${TARGETARCH:-"amd64"}
fi

export TARGETPLATFORM=${TARGETPLATFORM:-"${TARGETOS}/${TARGETARCH}"}

# container user and group
export CONTAINER_USER=${CONTAINER_USER:-"user"}
export CONTAINER_GROUP=${CONTAINER_GROUP:-"user"}

# container user ID and group ID
export CONTAINER_USER_ID=${CONTAINER_USER_ID:-$(id -u)}
export CONTAINER_GROUP_ID=${CONTAINER_GROUP_ID:-$(id -g)}

# set location of workspace directory
export WORKSPACE_ROOT_DIR=${WORKSPACE_ROOT_DIR:-"/home/${CONTAINER_USER}"}

docker buildx build --provenance=false --sbom=false --no-cache --push --platform "${TARGETPLATFORM}" \
              --build-arg CONTAINER_USER="${CONTAINER_USER}" \
              --build-arg CONTAINER_GROUP="${CONTAINER_GROUP}" \
              --build-arg CONTAINER_USER_ID="${CONTAINER_USER_ID}" \
              --build-arg CONTAINER_GROUP_ID="${CONTAINER_GROUP_ID}" \
              --build-arg WORKSPACE_ROOT_DIR="${WORKSPACE_ROOT_DIR}" \
              -t ghcr.io/stefanbosak/claude-cli:initial .
