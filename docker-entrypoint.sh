#!/bin/sh

launch() {

  if [ -z "$PASSWORD" ]; then
    PASSWORD=`tr -dc A-Za-z0-9 </dev/urandom | head -c 16`
  fi

  if [ ! -z "$OBFS" ]; then
    if [ "$OBFS" == "http" ]; then
      PLUGIN="obfs-server"
      PLUGIN_OPTS="obfs=http"
      PLUGIN_CLIENT_OPTS="obfs%3Dhttp"
    fi

    if [ "$OBFS" == "tls" ]; then
      PLUGIN="obfs-server"
      PLUGIN_OPTS="obfs=tls"
      PLUGIN_CLIENT_OPTS="obfs%3Dtls"
    fi

    if [ "$OBFS" == "ws" ]; then
      PLUGIN="v2ray-plugin"
      PLUGIN_OPTS="server"
      PLUGIN_CLIENT_OPTS=""
    fi

    if [ "$OBFS" == "wss" ]; then
      PLUGIN="v2ray-plugin"
      PLUGIN_OPTS="server;tls"
      PLUGIN_CLIENT_OPTS="tls"
    fi

    if [ "$OBFS" == "quic" ]; then
      PLUGIN="v2ray-plugin"
      PLUGIN_OPTS="server;mode=quic"
      PLUGIN_CLIENT_OPTS="mode%3Dquic"
    fi
  fi

  SERVER_PLUGIN=""
  if [ ! -z "$PLUGIN" ]; then
    SERVER_PLUGIN="--plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS}"
  fi

  SCHEME_USER_INFO=`echo -n "$METHOD:$PASSWORD" | base64 | sed 's/+/-/g;s/\//_/g'`

  echo ""
  echo -e "\033[32m  port:\033[0m ${SERVER_PORT}"
  echo -e "\033[32m  method:\033[0m ${METHOD}"
  echo -e "\033[32m  password:\033[0m ${PASSWORD}"
  echo -e "\033[32m  dns:\033[0m ${DNS}"
  if [ ! -z "$OBFS" ]; then
    echo -e "\033[32m  obfs:\033[0m ${OBFS}"
  fi
  echo ""
  echo -e "\033[32m  ss://${SCHEME_USER_INFO}@\033[31mIP:${SERVER_PORT}\033[32m\033[0m"
  if [ ! -z "$OBFS" ]; then
    echo -e "\033[32m  ss://${SCHEME_USER_INFO}@\033[31mIP:${SERVER_PORT}\033[32m/?plugin=${PLUGIN}%3B\033[31m${PLUGIN_CLIENT_OPTS}\033[32m\033[0m"
  fi
  echo ""
  echo -e "\033[32m  !! replace \033[31mIP:${SERVER_PORT}\033[32m to your public ip & port.\033[0m"
  echo ""

  ss-server \
    -s $SERVER_ADDR \
    -p $SERVER_PORT \
    -k $PASSWORD \
    -m $METHOD \
    -t $TIMEOUT \
    --fast-open \
    --reuse-port \
    -d $DNS \
    -u \
    $SERVER_PLUGIN \
    $ARGS
}


if [ -z "$@" ]; then
  launch
else
  exec "$@"
fi
