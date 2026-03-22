FROM ghcr.io/openclaw/openclaw:main

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION=3.14.3
ARG GO_VERSION=1.26.1

# 所有可变数据统一放到 /data
ENV APP_DATA=/data
ENV GOPATH=/data/go
ENV GOBIN=/data/bin
ENV PIP_ROOT_USER_ACTION=ignore
ENV PYTHONUSERBASE=/data/python
ENV PATH="/data/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN mkdir -p \
    /data/bin \
    /data/go \
    /data/python \
    /data/cache \
    /data/openclaw \
    /data/home

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

# Go，仅 amd64
RUN set -eux; \
    cd /tmp; \
    wget -O go.tgz "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    tar -C /usr/local -xzf go.tgz; \
    ln -sf /usr/local/go/bin/go /usr/local/bin/go; \
    ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt; \
    rm -f /tmp/go.tgz

# 给运行时一个固定 HOME，避免东西写回镜像层
ENV HOME=/data/home
WORKDIR /app