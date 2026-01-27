#!/bin/bash
#
# Anthropic Claude CLI runner wrapper
#

#
# Docker container Anthropic Claude CLI wrapper
#
claude() {
  # extract Docker GID from the system
  export DOCKER_GID=$(getent group docker | cut -d: -f3)

  docker run -it --rm \
    --group-add "${DOCKER_GID}" \
    --env-file "${HOME}/.claude/.env" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "${HOME}/.claude:/home/${USER}/.claude" \
    -v "${HOME}/workspace:/workspace" \
    -v "${HOME}/.docker:/home/${USER}/.docker:ro" \
    -v "${HOME}/.docker/mcp:/home/${USER}/.docker/mcp" \
    -w "/workspace" \
    ghcr.io/stefanbosak/claude-cli:initial \
    claude "$@"
}

# run
claude "${@}"
