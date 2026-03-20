FROM alpine/openclaw:2026.3.13-1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      bash \
      ca-certificates \
      curl \
      wget \
      git \
      jq \
      unzip \
      zip \
      xz-utils \
      file \
      procps \
      psmisc \
      iproute2 \
      net-tools \
      dnsutils \
      lsof \
      less \
      vim \
      nano \
      python3 \
      python3-pip \
      chromium \
      tini && \
    rm -rf /var/lib/apt/lists/*

# 删除旧 Go
RUN rm -f /usr/bin/go /usr/local/bin/go || true && \
    rm -rf /usr/local/go && \
    apt-get purge -y golang golang-go gccgo || true && \
    apt-get autoremove -y || true

# 安装新 Go
RUN wget -O /tmp/go.tar.gz https://go.dev/dl/go1.26.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm -f /tmp/go.tar.gz

# 兼容 chromium-browser 路径
RUN if [ -x /usr/bin/chromium ] && [ ! -e /usr/bin/chromium-browser ]; then \
      ln -s /usr/bin/chromium /usr/bin/chromium-browser; \
    fi

WORKDIR /app

ENV PATH=/usr/local/go/bin:$PATH \
    GOTOOLCHAIN=auto \
    NODE_ENV=production \
    PUPPETEER_SKIP_DOWNLOAD=true \
    CHROME_BIN=/usr/bin/chromium \
    CHROMIUM_BIN=/usr/bin/chromium \
    TINI_SUBREAPER=1 \
    TZ=Asia/Shanghai

ENTRYPOINT ["/usr/bin/tini", "-s", "--"]
CMD ["bash"]