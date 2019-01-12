#!/bin/sh

launch() {

  if [ ! -z "$PASSWORD" ]; then
    echo -e "\033[32mUsing explicitly passed password:\033[0m ${PASSWORD}"
  else
    PASSWORD=`hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom`
    echo -e "\033[33mGenerating random password:\033[0m ${PASSWORD}"
  fi


  GLOBAL_ADDR=`curl -s -4 "https://www.cloudflare.com/cdn-cgi/trace" | grep -Eo 'ip=\d+\.\d+\.\d+\.\d+' | awk -F '=' '{print $2}'`
  if [ -z "$GLOBAL_ADDR" ]; then
    GLOBAL_ADDR="0.0.0.0"
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
  fi

  SERVER_PLUGIN=""
  if [ ! -z "$PLUGIN" ]; then
    SERVER_PLUGIN="--plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS}"
  fi

  SCHEME_USER_INFO=`echo -n "$METHOD:$PASSWORD" | base64 | sed 's/+/-/g;s/\//_/g'`
  SCHEME="ss://${SCHEME_USER_INFO}@${GLOBAL_ADDR}:${SERVER_PORT}"

  echo ""
  echo -e "\033[32m  server address:\033[0m ${GLOBAL_ADDR}"
  echo -e "\033[32m  method:\033[0m ${METHOD}"
  echo -e "\033[32m  password:\033[0m ${PASSWORD}"
  echo -e "\033[32m  dns:\033[0m ${DNS}"
  if [ ! -z "$OBFS" ]; then
    echo -e "\033[32m  obfs:\033[0m ${OBFS}"
  fi
  echo ""
  echo -e "\033[32m  ss://${SCHEME_USER_INFO}@${GLOBAL_ADDR}:\033[31m${SERVER_PORT}\033[32m\033[0m"
  if [ ! -z "$OBFS" ]; then
    echo -e "\033[32m  ss://${SCHEME_USER_INFO}@${GLOBAL_ADDR}:\033[31m${SERVER_PORT_OBFS}\033[32m/?plugin=${PLUGIN}%3B\033[31m${PLUGIN_CLIENT_OPTS}\033[32m\033[0m"
  fi
  echo ""
  echo -e "\033[32m  !! replace \033[31m${SERVER_PORT}\033[32m to your different port.\033[0m"
  echo ""

  echo -e "\033[33mss-server start!\033[0m"
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
