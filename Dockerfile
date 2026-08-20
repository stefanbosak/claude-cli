# Non-hardened alternative
#FROM debian:stable-slim

# Hardened
FROM dhi.io/debian-base:trixie-debian13-dev

# Build arguments
ARG TARGETARCH
ARG TARGETOS

ARG CONTAINER_USER=user
ARG CONTAINER_GROUP=user

ARG CONTAINER_USER_ID=1000
ARG CONTAINER_GROUP_ID=1000

ARG WORKSPACE_ROOT_DIR="/home/${CONTAINER_USER}"

WORKDIR "${WORKSPACE_ROOT_DIR}"

# OCI Standard Labels
# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.description="Anthropic claude CLI container and tooling"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    bubblewrap \
    bc \
    ca-certificates \
    curl \
    dnsutils \
    git \
    gzip \
    iproute2 \
    iputils-ping \
    jq \
    kmod \
    lsof \
    openssh-client \
    pandoc \
    pigz \
    procps \
    psmisc \
    ripgrep \
    rsync \
    socat \
    unzip \
    wget \
    whois \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

COPY "./tools.yaml" "/usr/local/bin/tools.yaml"

RUN if getent group "${CONTAINER_GROUP_ID}" > /dev/null; then \
      _existing_group="$(getent group "${CONTAINER_GROUP_ID}" | cut -d: -f1)"; \
      if [ "${_existing_group}" != "${CONTAINER_GROUP}" ]; then \
        groupmod -n "${CONTAINER_GROUP}" "${_existing_group}"; \
      fi; \
    else \
      groupadd --gid "${CONTAINER_GROUP_ID}" "${CONTAINER_GROUP}"; \
    fi \
    && if getent passwd "${CONTAINER_USER_ID}" > /dev/null; then \
         _existing_user="$(getent passwd "${CONTAINER_USER_ID}" | cut -d: -f1)"; \
         if [ "${_existing_user}" != "${CONTAINER_USER}" ]; then \
           if [ -d "/home/${_existing_user}" ]; then \
             mv "/home/${_existing_user}" "/home/${CONTAINER_USER}"; \
           fi; \
           usermod -d "/home/${CONTAINER_USER}" -l "${CONTAINER_USER}" "${_existing_user}"; \
         fi; \
       else \
         useradd \
           --uid "${CONTAINER_USER_ID}" \
           --gid "${CONTAINER_GROUP_ID}" \
           --groups "${CONTAINER_GROUP}" \
           -M -d "${WORKSPACE_ROOT_DIR}" \
           -s /bin/bash \
           "${CONTAINER_USER}"; \
       fi \
    && mkdir -p /workspace \
    && chown -R "${CONTAINER_USER}:${CONTAINER_GROUP}" "${WORKSPACE_ROOT_DIR}" /workspace \
  # Install uv (Python package manager)
  && curl -LsSf https://astral.sh/uv/install.sh \
      | UV_INSTALL_DIR=/usr/local/bin sh \
  # Install bun (all-in-one JS toolkit)
  && curl -fsSL https://bun.com/install \
      | BUN_INSTALL=/usr/local bash \
  # Install mdflow
  && BUN_INSTALL=/usr/local bun install --global mdflow \
  # Install fabric
  && curl -fsSL "https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh" \
     | INSTALL_DIR=/usr/local/bin bash \
  # Install Docker-in-Docker
  # Note: DinD via QEMU on ARM64 not supported
  # (ARM64 requires ARM64 kernel from host, not available on AMD64 host)
  && curl -fsSL https://test.docker.com | sh; \
  getent group docker >/dev/null 2>&1 || groupadd --system docker \
  && if getent group docker > /dev/null 2>&1; then \
       usermod -aG docker "${CONTAINER_USER}"; \
     fi \
  && ln -s "${WORKSPACE_ROOT_DIR}/.local/bin/claude" "/usr/local/bin/claude"

# Switch to non-root user
USER "${CONTAINER_USER}"

RUN curl -fsSL https://claude.ai/install.sh | bash \
    && cp /etc/skel/.bashrc "${WORKSPACE_ROOT_DIR}" \
    && echo 'export PATH=${HOME}/.local/bin:${PATH}' >> "${WORKSPACE_ROOT_DIR}/.bashrc"

CMD ["claude"]
