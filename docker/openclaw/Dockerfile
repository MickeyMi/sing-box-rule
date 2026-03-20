FROM alpine/openclaw:2026.3.13-1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION=3.14.3
ARG GO_VERSION=1.26.1
ARG NODE_MAJOR=24
ARG NPM_VERSION=11.12.0

ENV PATH="/usr/local/go/bin:/usr/local/node/bin:${PATH}"

# 删除旧版本并安装基础依赖
RUN set -eux; \
    apt-get update; \
    apt-get remove -y python3 python3-pip nodejs npm golang golang-go || true; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git \
        bash \
        xz-utils \
        unzip \
        tar \
        build-essential \
        pkg-config \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        libncursesw5-dev \
        libgdbm-dev \
        liblzma-dev \
        tk-dev \
        uuid-dev; \
    rm -rf \
        /usr/local/go \
        /usr/local/node \
        /usr/local/bin/python \
        /usr/local/bin/python3 \
        /usr/local/bin/pip \
        /usr/local/bin/pip3 \
        /usr/local/lib/python* \
        /root/.npm \
        /tmp/*; \
    rm -rf /var/lib/apt/lists/*

# 安装 Python
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
    cd /; \
    rm -rf /tmp/Python* /tmp/*

# 安装 Go
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
    rm -f /tmp/go.tgz; \
    go version

# 安装 Node.js 和 npm
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
    ln -sf /usr/local/node/bin/npm /usr/local/bin/npm; \
    ln -sf /usr/local/node/bin/npx /usr/local/bin/npx; \
    npm install -g "npm@${NPM_VERSION}"; \
    rm -f /tmp/node.tar.xz; \
    node --version; \
    npm --version

RUN set -eux; \
    python3 --version; \
    pip3 --version; \
    go version; \
    node --version; \
    npm --version