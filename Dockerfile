FROM debian:bookworm

# Define environment variables for versions and paths
ENV FISH_VERSION=3.7.1 \
    NODE_VERSION=v22.0.0 \
    GO_VERSION=1.24.0 \
    GH_CLI_VERSION=2.54.0 \
    GOLANGCI_LINT_VERSION=latest \
    VIRTUAL_ENV=/opt/python \
    DOCKER_COMPOSE_VERSION=2.29.2 \
    ZIG_VERSION=0.16.0-dev.1634+b27bdd5af

ENV PATH="/root/.cargo/bin:/opt/go-${GO_VERSION}/bin:/root/go/bin:/opt/node-${NODE_VERSION}-linux-x64/bin:/opt/python/bin:/opt/zig-linux-x86_64-${ZIG_VERSION}:$PATH"

# Install necessary packages
RUN apt update && apt install -y curl git clang cmake gettext libbz2-dev libreadline-dev libedit-dev zlib1g-dev pkg-config xz-utils unzip python3-pip python3.11-venv

# Install Ansible
RUN python3 -m venv /opt/python &&\
    /opt/python/bin/pip install ansible

# Install Fish Shell
RUN curl -fsSL https://github.com/fish-shell/fish-shell/releases/download/${FISH_VERSION}/fish-${FISH_VERSION}.tar.xz | tar --lzma -xv -C /opt/ &&\
    cd /opt/fish-${FISH_VERSION} &&\
    cmake -DCMAKE_C_COMPILER=/usr/bin/clang . &&\
    make &&\
    make install &&\
    rm -rf /opt/fish-${FISH_VERSION}

# Install Node.js
RUN curl -fsSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz -o - | tar --lzma -xv -C /opt

# Install Go
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o - | tar -xzv -C /opt  --transform "s/^go/go-${GO_VERSION}/"

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Install Docker and jq
RUN apt update && apt install -y docker.io jq

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Install GitHub CLI
RUN curl -fsSL https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_amd64.tar.gz -o - | tar -xzv -C /usr/local  --transform "s/^gh_${GH_CLI_VERSION}_linux_amd64\///"

# Install GolangCI-Lint
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@${GOLANGCI_LINT_VERSION}

# Install Zig
RUN curl -fsSL https://ziglang.org/builds/zig-x86_64-linux-${ZIG_VERSION}.tar.xz -o - | tar --lzma -xv -C /opt
