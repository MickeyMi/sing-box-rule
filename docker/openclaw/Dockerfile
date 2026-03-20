FROM alpine/openclaw:2026.3.13-1

SHELL ["/bin/sh", "-exc"]

ARG PYTHON_VERSION=3.14.3
ARG GO_VERSION=1.26.1
ARG NODE_MAJOR=24
ARG NPM_VERSION=11.12.0

ENV PATH="/usr/local/go/bin:/usr/local/node/bin:${PATH}"

# 删除旧版本 / 安装基础依赖
RUN apk update && apk add --no-cache \
    bash \
    curl \
    wget \
    ca-certificates \
    tar \
    xz \
    unzip \
    git \
    build-base \
    linux-headers \
    libffi-dev \
    openssl-dev \
    zlib-dev \
    bzip2-dev \
    xz-dev \
    readline-dev \
    sqlite-dev \
    ncurses-dev \
    tk-dev \
    gdbm-dev \
    libc6-compat \
    && update-ca-certificates \
    && apk del --no-network python3 py3-pip go nodejs npm 2>/dev/null || true \
    && rm -rf \
      /usr/local/go \
      /usr/local/node \
      /usr/local/bin/python* \
      /usr/local/bin/pip* \
      /usr/local/lib/python* \
      /root/.npm \
      /tmp/*

# 安装 Python
RUN ARCH="$(uname -m)" \
    && case "${ARCH}" in \
         x86_64) PY_ARCH="x86_64" ;; \
         aarch64) PY_ARCH="aarch64" ;; \
         *) echo "Unsupported arch: ${ARCH}"; exit 1 ;; \
       esac \
    && wget -O /tmp/python.tgz "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" \
    && tar -xzf /tmp/python.tgz -C /tmp \
    && cd "/tmp/Python-${PYTHON_VERSION}" \
    && ./configure --prefix=/usr/local --enable-optimizations --with-ensurepip=install \
    && make -j"$(nproc)" \
    && make altinstall \
    && ln -sf "/usr/local/bin/python3.14" /usr/local/bin/python3 \
    && ln -sf "/usr/local/bin/python3.14" /usr/local/bin/python \
    && ln -sf "/usr/local/bin/pip3.14" /usr/local/bin/pip3 \
    && ln -sf "/usr/local/bin/pip3.14" /usr/local/bin/pip \
    && python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel \
    && rm -rf /tmp/python.tgz "/tmp/Python-${PYTHON_VERSION}"

# 安装 Go
RUN ARCH="$(uname -m)" \
    && case "${ARCH}" in \
         x86_64) GO_ARCH="amd64" ;; \
         aarch64) GO_ARCH="arm64" ;; \
         *) echo "Unsupported arch: ${ARCH}"; exit 1 ;; \
       esac \
    && wget -O /tmp/go.tgz "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" \
    && tar -C /usr/local -xzf /tmp/go.tgz \
    && ln -sf /usr/local/go/bin/go /usr/local/bin/go \
    && ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt \
    && rm -f /tmp/go.tgz \
    && go version

# 安装 Node.js + npm
RUN ARCH="$(uname -m)" \
    && case "${ARCH}" in \
         x86_64) NODE_ARCH="x64" ;; \
         aarch64) NODE_ARCH="arm64" ;; \
         *) echo "Unsupported arch: ${ARCH}"; exit 1 ;; \
       esac \
    && wget -O /tmp/node.tar.xz "https://nodejs.org/dist/latest-v${NODE_MAJOR}.x/node-$(wget -qO- https://nodejs.org/dist/latest-v${NODE_MAJOR}.x/SHASUMS256.txt | awk '/linux-'${NODE_ARCH}'\.tar\.xz$/ {print $2; exit}')" \
    && mkdir -p /usr/local/node \
    && tar -xJf /tmp/node.tar.xz -C /usr/local/node --strip-components=1 \
    && ln -sf /usr/local/node/bin/node /usr/local/bin/node \
    && ln -sf /usr/local/node/bin/npm /usr/local/bin/npm \
    && ln -sf /usr/local/node/bin/npx /usr/local/bin/npx \
    && npm install -g "npm@${NPM_VERSION}" \
    && rm -f /tmp/node.tar.xz \
    && node --version \
    && npm --version

RUN python3 --version \
    && pip3 --version \
    && go version \
    && node --version \
    && npm --version