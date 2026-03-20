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

# 安装官方 Go 1.26.1
RUN wget -O /tmp/go.tar.gz https://go.dev/dl/go1.26.1.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm -f /tmp/go.tar.gz

# 兼容 chromium-browser 路径
RUN if [ -x /usr/bin/chromium ] && [ ! -e /usr/bin/chromium-browser ]; then \
      ln -s /usr/bin/chromium /usr/bin/chromium-browser; \
    fi

WORKDIR /app

ENV PATH=/usr/local/go/bin:$PATH \
    NODE_ENV=production \
    PUPPETEER_SKIP_DOWNLOAD=true \
    CHROME_BIN=/usr/bin/chromium \
    CHROMIUM_BIN=/usr/bin/chromium \
    GO111MODULE=on \
    CGO_ENABLED=1 \
    TINI_SUBREAPER=1 \
    TZ=Asia/Shanghai

ENTRYPOINT ["/usr/bin/tini", "-s", "--"]
CMD ["openclaw", "doctor"]