FROM alpine/openclaw:2026.3.13-1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# 安装 OpenClaw 常用运行依赖
# - golang: Go 工具链
# - python3/python3-pip: Python 运行时和 pip
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
      tini \
      golang && \
    rm -rf /var/lib/apt/lists/*

# 兼容 chromium-browser 路径
RUN if [ -x /usr/bin/chromium ] && [ ! -e /usr/bin/chromium-browser ]; then \
      ln -s /usr/bin/chromium /usr/bin/chromium-browser; \
    fi

WORKDIR /app

ENV NODE_ENV=production \
    PUPPETEER_SKIP_DOWNLOAD=true \
    CHROME_BIN=/usr/bin/chromium \
    CHROMIUM_BIN=/usr/bin/chromium \
    GO111MODULE=on \
    CGO_ENABLED=1 \
    TZ=Asia/Shanghai

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["openclaw", "doctor"]