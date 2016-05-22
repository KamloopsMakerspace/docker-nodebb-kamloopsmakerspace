#!/bin/sh

mkdir -p /data/nodebb

cd /opt/nodebb

if [ ! -h "/opt/nodebb/public/uploads" ]; then
#    mv public/uploads /data/nodebb/uploads
    mkdir -p public/uploads
    ln -s /data/nodebb/uploads public/uploads
fi

eval "database=redis redis__host=localhost redis__port=6379 node app.js"
