FROM alpine:3.8 AS builder

LABEL maintainer="metowolf <i@i-meto.com>"

ENV SS_VERSION 3.2.3
ENV SS_OBFS_VERSION 0.0.5

RUN apk upgrade \
    && apk add \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      git \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
      udns-dev \
    && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && cd shadowsocks-libev \
    && git checkout v$SS_VERSION \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make install \
    && cd .. \
    && git clone https://github.com/shadowsocks/simple-obfs.git \
    && cd simple-obfs \
    && git checkout v$SS_OBFS_VERSION \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make install


FROM alpine:3.8

LABEL maintainer="metowolf <i@i-meto.com>"

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV SERVER_PORT_OBFS 8139
ENV PASSWORD=
ENV METHOD aes-256-gcm
ENV TIMEOUT 300
ENV DNS_ADDRS 8.8.8.8,8.8.4.4
ENV OBFS=
ENV ARGS=

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp
EXPOSE $SERVER_PORT_OBFS/tcp
EXPOSE $SERVER_PORT_OBFS/udp

COPY --from=builder /usr/bin/ss-* /usr/bin/
COPY --from=builder /usr/bin/obfs-* /usr/bin/

RUN apk add --no-cache \
    rng-tools \
    curl \
    $(scanelf --needed --nobanner /usr/bin/ss-* \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u)

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
