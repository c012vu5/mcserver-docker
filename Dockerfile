FROM archlinux AS build
LABEL maintainer="c012vu5"
LABEL description="Image to build mcrcon"
RUN pacman -Syu --noconfirm \
                gcc \
                git \
                make \
                && \
    git clone https://github.com/Tiiffi/mcrcon.git && \
    cd mcrcon && \
    make && \
    make install

FROM archlinux
LABEL maintainer="c012vu5"
LABEL description="Container to run minecraft server."
COPY --chmod=755 entrypoint.sh /usr/local/bin/
COPY --from=build /usr/local/bin/mcrcon /usr/local/bin/
RUN pacman -Syu --noconfirm jre-openjdk-headless
WORKDIR /mnt/current
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
