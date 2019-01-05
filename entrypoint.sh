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
    echo -e "\033[33mobfs-server start!\033[0m"
    obfs-server \
      -s $SERVER_ADDR \
      -p $SERVER_PORT_OBFS \
      --obfs $OBFS \
      -r 127.0.0.1:${SERVER_PORT} &
  fi
  

  SCHEME_USER_INFO=`echo -n "$METHOD:$PASSWORD" | base64 | sed 's/+/-/g;s/\//_/g'`
  SCHEME="ss://${SCHEME_USER_INFO}@${GLOBAL_ADDR}:${SERVER_PORT}"

  echo ""
  echo -e "\033[32m  server address:\033[0m ${GLOBAL_ADDR}"
  echo -e "\033[32m  method:\033[0m ${METHOD}"
  echo -e "\033[32m  password:\033[0m ${PASSWORD}"
  if [ ! -z "$OBFS" ]; then
    echo -e "\033[32m  obfs:\033[0m ${OBFS}"
  fi
  echo ""
  echo -e "\033[32m  ss://${SCHEME_USER_INFO}@${GLOBAL_ADDR}:\033[31m${SERVER_PORT}\033[32m\033[0m"
  if [ ! -z "$OBFS" ]; then
    echo -e "\033[32m  ss://${SCHEME_USER_INFO}@${GLOBAL_ADDR}:\033[31m${SERVER_PORT_OBFS}\033[32m/?plugin=obfs-local%3Bobfs%3D\033[31m${OBFS}\033[32m\033[0m"
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
    -d $DNS_ADDRS \
    -u \
    $ARGS
}


if [ -z "$@" ]; then
  launch
else
  exec "$@"
fi
