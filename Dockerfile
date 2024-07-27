FROM debian:bullseye

RUN apt update && apt install -y curl git clang cmake gettext libbz2-dev libreadline-dev libedit-dev zlib1g-dev pkg-config xz-utils unzip
ENV PATH "/root/.cargo/bin:/opt/go-1.20.4/bin:/root/.deno/bin:/opt/node-v18.16.0-linux-x64/bin:$PATH"
RUN curl -fsSL https://github.com/fish-shell/fish-shell/releases/download/3.6.1/fish-3.6.1.tar.xz | tar --lzma -xv -C /opt/ &&\
    cd /opt/fish-3.6.1 &&\
    cmake -DCMAKE_C_COMPILER=/usr/bin/clang . &&\
    make &&\
    make install &&\
    rm -rf /opt/fish-3.6.1
RUN curl -fsSL https://nodejs.org/dist/v18.16.0/node-v18.16.0-linux-x64.tar.xz -o - | tar --lzma -xv -C /opt
RUN curl -fsSL https://go.dev/dl/go1.20.4.linux-amd64.tar.gz -o - | tar -xzv -C /opt  --transform "s/^go/go-1.20.4/"
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
RUN apt update && apt install -y docker.io jq
RUN curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN curl -fsSL https://github.com/cli/cli/releases/download/v2.32.1/gh_2.32.1_linux_amd64.tar.gz -o - | tar -xzv -C /usr/local  --transform "s/^gh_2.32.1_linux_amd64\///"
