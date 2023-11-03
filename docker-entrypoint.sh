#!/bin/sh
set -e

launch() {

  if [ -z "$PASSWORD" ]; then
    PASSWORD=`tr -dc A-Za-z0-9 </dev/urandom | head -c 16`
    echo "PASSWORD=$PASSWORD"
  fi

  ss-server \
    -s $SERVER_ADDR:$SERVER_PORT \
    -k $PASSWORD \
    -m $METHOD \
    --tcp-fast-open \
    --dns $DNS \
    $ARGS
}

if [ "$1" == "auto" ]; then
  launch
elif [ "${1#-}" != "$1" ]; then
	exec ssserver "$@"
else
  exec "$@"
fi
