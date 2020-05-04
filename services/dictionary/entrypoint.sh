#!/bin/sh

redis-server --daemonize yes && sleep 1

awk '{print "SADD", "dict", $1}' /usr/src/data/words_alpha.txt | awk 'sub("$", "\r")' | redis-cli --pipe

redis-cli save

redis-cli shutdown

redis-server

exec "$@"
