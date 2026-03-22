FROM ghcr.io/openclaw/openclaw:main

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION=3.14.3
ARG GO_VERSION=1.26.1
ARG NODE_MAJOR=24
ARG NPM_VERSION=11.12.0

# 所有可变数据统一放到 /data
ENV APP_DATA=/data
ENV HOME=/data/home
ENV TMPDIR=/data/tmp

ENV GOPATH=/data/go
ENV GOBIN=/data/bin

ENV NPM_CONFIG_PREFIX=/data/npm-global
ENV NPM_CONFIG_CACHE=/data/npm-cache

ENV PYTHONUSERBASE=/data/python
ENV PIP_ROOT_USER_ACTION=ignore
ENV PIP_CACHE_DIR=/data/pip-cache

# 不把 /usr/local/node/bin 放进 PATH，避免命中 Node 自带的 npm 11.9.0
ENV PATH="/data/bin:/data/npm-global/bin:/data/python/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN mkdir -p \
    /data/bin \
    /data/go \
    /data/npm-global \
    /data/npm-cache \
    /data/python \
    /data/pip-cache \
    /data/cache \
    /data/openclaw \
    /data/home \
    /data/tmp \
    /data/logs \
    /home/node

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates curl wget git bash xz-utils unzip tar \
        build-essential pkg-config \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
        libsqlite3-dev libffi-dev libncursesw5-dev libgdbm-dev \
        liblzma-dev tk-dev uuid-dev; \
    rm -rf /var/lib/apt/lists/*

# Python
RUN set -eux; \
    cd /tmp; \
    wget -O Python.tgz "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"; \
    tar -xzf Python.tgz; \
    cd "Python-${PYTHON_VERSION}"; \
    ./configure --prefix=/usr/local --enable-optimizations --with-ensurepip=install; \
    make -j"$(nproc)"; \
    make altinstall; \
    PY_SHORT="$(echo "${PYTHON_VERSION}" | awk -F. '{print $1 "." $2}')"; \
    ln -sf "/usr/local/bin/python${PY_SHORT}" /usr/local/bin/python3; \
    ln -sf "/usr/local/bin/python${PY_SHORT}" /usr/local/bin/python; \
    ln -sf "/usr/local/bin/pip${PY_SHORT}" /usr/local/bin/pip3; \
    ln -sf "/usr/local/bin/pip${PY_SHORT}" /usr/local/bin/pip; \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel; \
    rm -rf /tmp/*

# Go
RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
      amd64) GOARCH='amd64' ;; \
      arm64) GOARCH='arm64' ;; \
      *) echo "Unsupported arch: ${ARCH}"; exit 1 ;; \
    esac; \
    cd /tmp; \
    wget -O go.tgz "https://go.dev/dl/go${GO_VERSION}.linux-${GOARCH}.tar.gz"; \
    tar -C /usr/local -xzf go.tgz; \
    ln -sf /usr/local/go/bin/go /usr/local/bin/go; \
    ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt; \
    rm -f /tmp/go.tgz

# Node.js + npm
RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
      amd64) NODEARCH='x64' ;; \
      arm64) NODEARCH='arm64' ;; \
      *) echo "Unsupported arch: ${ARCH}"; exit 1 ;; \
    esac; \
    cd /tmp; \
    NODE_VERSION="$(curl -fsSL https://nodejs.org/dist/latest-v${NODE_MAJOR}.x/SHASUMS256.txt | awk '/linux-'"${NODEARCH}"'\.tar\.xz$/ {gsub(/^node-v|-.*/, "", $2); print $2; exit}')"; \
    wget -O node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODEARCH}.tar.xz"; \
    mkdir -p /usr/local/node; \
    tar -xJf node.tar.xz -C /usr/local/node --strip-components=1; \
    ln -sf /usr/local/node/bin/node /usr/local/bin/node; \
    mkdir -p /data/npm-global /data/npm-cache; \
    /usr/local/node/bin/npm install -g "npm@${NPM_VERSION}" --prefix /data/npm-global; \
    ln -sf /data/npm-global/bin/npm /usr/local/bin/npm; \
    ln -sf /data/npm-global/bin/npx /usr/local/bin/npx; \
    npm -v; \
    npx -v; \
    rm -f /tmp/node.tar.xz

# 可选：验证最终路径
RUN set -eux; \
    echo "node => $(which node)"; \
    echo "npm  => $(which npm)"; \
    echo "npx  => $(which npx)"; \
    node -v; \
    npm -v; \
    npx -v

ENV OPENCLAW_TMP_DIR=/data/tmp
WORKDIR /app
VOLUME ["/data"]