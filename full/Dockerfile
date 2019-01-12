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


FROM golang:alpine as v2ray-builder

LABEL maintainer="metowolf <i@i-meto.com>"

ENV VERSION 20190109

RUN apk add git \
    && cd /go/src \
    && wget https://github.com/madeye/v2ray-plugin/archive/v$VERSION.tar.gz \
    && tar xzvf v$VERSION.tar.gz \
    && go get v2ray-plugin-$VERSION \
    && mv /go/bin/v2ray-plugin-$VERSION /go/bin/v2ray-plugin


FROM alpine:3.8

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

COPY --from=builder /usr/bin/ss-* /usr/local/bin/
COPY --from=builder /usr/bin/obfs-* /usr/local/bin/
COPY --from=v2ray-builder /go/bin/v2ray-* /usr/local/bin/

RUN apk add --no-cache \
    rng-tools \
    curl \
    $(scanelf --needed --nobanner /usr/local/bin/* \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u)

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
