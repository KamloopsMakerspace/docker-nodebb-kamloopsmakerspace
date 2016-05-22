#!/bin/sh

mkdir -p /data/redis

redis-server /etc/redis/redis.conf

redis-cli config set protected-mode no
