FROM fedora:latest AS base

ENV KREW_ROOT=/home/debugger/.krew \
    PATH="/home/debugger/.krew/bin:${PATH}"

RUN dnf -y install \
    curl \
    wget \
    git \
    git-lfs \
    vim-minimal \
    nano \
    jq \
    yq \
    skopeo \
    bind-utils \
    iproute \
    iputils \
    net-tools \
    nmap-ncat \
    socat \
    tcpdump \
    iperf3 \
    strace \
    lsof \
    htop \
    procps-ng \
    postgresql \
    mysql \
    redis \
    rabbitmq-server \
    siege \
    grpcurl \
    helm \
    unzip \
    tar \
    gzip \
    && dnf clean all

RUN KREW_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/krew/releases/latest | jq -r '.tag_name') && \
    ARCH=$(uname -m) && \
    case $ARCH in \
        x86_64) ARCH="amd64" ;; \
        aarch64) ARCH="arm64" ;; \
    esac && \
    cd /tmp && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/${KREW_VERSION}/krew-linux_${ARCH}.tar.gz" && \
    tar zxvf krew-linux_${ARCH}.tar.gz && \
    ./krew-linux_${ARCH} install krew && \
    rm -rf /tmp/krew-* && \
    echo "krew installed successfully"

RUN KUBECTL_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r '.tag_name') && \
    ARCH=$(uname -m) && \
    case $ARCH in \
        x86_64) ARCH="amd64" ;; \
        aarch64) ARCH="arm64" ;; \
    esac && \
    curl -Lo /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" && \
    chmod +x /usr/local/bin/kubectl

RUN STERN_VERSION=$(curl -s https://api.github.com/repos/stern/stern/releases/latest | jq -r '.tag_name') && \
    ARCH=$(uname -m) && \
    case $ARCH in \
        x86_64) ARCH="amd64" ;; \
        aarch64) ARCH="arm64" ;; \
    esac && \
    curl -Lo /tmp/stern.tar.gz "https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_${ARCH}.tar.gz" && \
    tar -xzf /tmp/stern.tar.gz -C /tmp && \
    mv /tmp/stern /usr/local/bin/stern && \
    chmod +x /usr/local/bin/stern && \
    rm -rf /tmp/stern*

RUN MONGOSH_VERSION=$(curl -s https://api.github.com/repos/mongodb-js/mongosh/releases/latest | jq -r '.tag_name') && \
    ARCH=$(uname -m) && \
    case $ARCH in \
        x86_64) ARCH="x64" ;; \
        aarch64) ARCH="arm64" ;; \
    esac && \
    curl -Lo /tmp/mongosh.tgz "https://github.com/mongodb-js/mongosh/releases/download/${MONGOSH_VERSION}/mongosh-${MONGOSH_VERSION#v}-linux-${ARCH}.tgz" && \
    tar -xzf /tmp/mongosh.tgz -C /tmp && \
    mv /tmp/mongosh-*/bin/mongosh /usr/local/bin/mongosh && \
    chmod +x /usr/local/bin/mongosh && \
    rm -rf /tmp/mongosh*

RUN useradd -m -s /bin/bash debugger && \
    mkdir -p /home/debugger/.kube /home/debugger/.config/helm && \
    chown -R debugger:debugger /home/debugger

WORKDIR /home/debugger

USER debugger

CMD ["/bin/bash"]

FROM base AS tmux

USER root

RUN dnf -y install tmux && dnf clean all

COPY tmux.conf /home/debugger/.tmux.conf
COPY entrypoint-tmux.sh /entrypoint-tmux.sh
RUN chmod +x /entrypoint-tmux.sh && \
    chown debugger:debugger /home/debugger/.tmux.conf

USER debugger

ENTRYPOINT ["/entrypoint-tmux.sh"]