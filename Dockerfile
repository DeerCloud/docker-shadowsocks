FROM alpine:latest

LABEL maintainer="metowolf <i@i-meto.com>"

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD aes-256-gcm
ENV DNS 8.8.8.8,8.8.4.4
ENV ARGS=

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  shadowsocks-rust

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["auto"]
ENTRYPOINT ["docker-entrypoint.sh"]
