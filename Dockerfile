FROM alpine:edge AS ss-builder

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
    && ./configure --prefix=/usr/local --disable-documentation \
    && make install \
    && cd .. \
    && git clone https://github.com/shadowsocks/simple-obfs.git \
    && cd simple-obfs \
    && git checkout v$SS_OBFS_VERSION \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local --disable-documentation \
    && make install


FROM golang:alpine AS v2ray-builder

LABEL maintainer="metowolf <i@i-meto.com>"

ENV VERSION 1.1.0

RUN apk upgrade \
    && apk add \
      gcc \
      git \
      musl-dev \
      upx \
    && mkdir build \
    && cd build \
    && wget https://github.com/shadowsocks/v2ray-plugin/archive/v${VERSION}.tar.gz \
    && tar xzvf v${VERSION}.tar.gz \
    && cd v2ray-plugin-${VERSION} \
    && go build -ldflags "-s -w" \
    && upx --brute v2ray-plugin \
    && mv v2ray-plugin /usr/local/bin/


FROM alpine:3.9

LABEL maintainer="metowolf <i@i-meto.com>"

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD aes-256-gcm
ENV TIMEOUT 300
ENV DNS 8.8.8.8,8.8.4.4
ENV OBFS=
ENV PLUGIN=
ENV PLUGIN_OPTS=
ENV ARGS=

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

COPY --from=ss-builder /usr/local/bin/* /usr/local/bin/
RUN apk add --no-cache \
      rng-tools \
      $(scanelf --needed --nobanner /usr/local/bin/* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
    && sed 's@#!/bin/bash@#!/bin/sh@g' /usr/local/bin/ss-nat | tee /usr/local/bin/ss-nat > /dev/null
COPY --from=v2ray-builder /usr/local/bin/v2ray-* /usr/local/bin/

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
