# Non-hardened alternative
#FROM debian:stable-slim

# Hardened
FROM dhi.io/debian-base:trixie

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
LABEL org.opencontainers.image.authors="Stefan Bosak" \
      org.opencontainers.image.url="https://github.com/stefanbosak/claude-cli" \
      org.opencontainers.image.source="https://github.com/stefanbosak/claude-cli" \
      org.opencontainers.image.title="Anthropic claude CLI container" \
      org.opencontainers.image.description="Debian-based Anthropic claude CLI container"

# Python 3.14 from deadsnakes PPA (not in Debian 13/trixie distribution)
COPY ./deadsnakes.list /etc/apt/sources.list.d/deadsnakes.list
COPY ./deadsnakes.gpg /usr/share/keyrings/deadsnakes.gpg

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    bc \
    ca-certificates \
    curl \
    dnsutils \
    gh \
    git \
    gzip \
    iproute2 \
    iputils-ping \
    jq \
    kmod \
    lsof \
    openssh-client \
    pigz \
    procps \
    psmisc \
    python3.14-venv \
    ripgrep \
    rsync \
    socat \
    unzip \
    vim \
    wget \
    whois \
  && apt-get remove -y python3 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.14 0 \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.14 0 \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

RUN if ! getent passwd ${CONTAINER_USER_ID}; then \
        groupadd --gid ${CONTAINER_GROUP_ID} "${CONTAINER_GROUP}" && \
        useradd --gid ${CONTAINER_GROUP_ID} --groups "${CONTAINER_USER}" -M -d "${WORKSPACE_ROOT_DIR}" --uid ${CONTAINER_USER_ID} "${CONTAINER_USER}" -s "/bin/bash"; \
        chown -R "${CONTAINER_USER}:${CONTAINER_GROUP}" "${WORKSPACE_ROOT_DIR}"; \
    else \
        rm -fr "/home/${CONTAINER_USER}" && \
        usermod -M -d "${WORKSPACE_ROOT_DIR}" -c "${CONTAINER_USER}" "debian" && \
        groupmod -n "${CONTAINER_USER}" "debian" && \
        usermod -l "${CONTAINER_USER}" "debian" && \
        chown -R "${CONTAINER_USER}:${CONTAINER_GROUP}" "${WORKSPACE_ROOT_DIR}"; \
    fi \
  # Install uv (Python package manager)
  && curl -LsSf https://astral.sh/uv/install.sh \
      | UV_INSTALL_DIR=/usr/local/bin sh \
  # Install Docker-in-Docker
  # Note: DinD via QEMU on ARM64 not supported
  # (ARM64 requires ARM64 kernel from host, not available on AMD64 host)
  && curl -fsSL https://get.docker.com | sh \
  && if ! getent group docker > /dev/null 2>&1; then \
       groupadd -g 999 docker; \
     fi \
  && usermod -aG docker "${CONTAINER_USER}" \
  && ln -s "${WORKSPACE_ROOT_DIR}/.local/bin/claude" "/usr/local/bin/claude"

# Switch to non-root user
USER "${CONTAINER_USER}"

RUN curl -fsSL https://claude.ai/install.sh | bash \
    && cp /etc/skel/.bashrc "${WORKSPACE_ROOT_DIR}" \
    && echo 'export PATH=${HOME}/.local/bin:${PATH}' >> "${WORKSPACE_ROOT_DIR}/.bashrc"

CMD ["claude"]
