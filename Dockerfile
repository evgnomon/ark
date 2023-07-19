FROM debian:11.7
RUN apt update && apt install -y curl git clang cmake gettext libbz2-dev libreadline-dev libedit-dev zlib1g-dev
RUN apt update && apt install -y xz-utils 
RUN curl -LsS https://github.com/fish-shell/fish-shell/releases/download/3.6.1/fish-3.6.1.tar.xz | tar --lzma -xv -C /opt/ &&\
    cd /opt/fish-3.6.1 &&\
    cmake -DCMAKE_C_COMPILER=/usr/bin/clang . &&\
    make &&\
    make install &&\
    rm -rf /opt/fish-3.6.1
RUN apt update && apt install -y docker.io jq
RUN curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
