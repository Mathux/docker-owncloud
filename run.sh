#!/bin/bash

# Run OwnCloud
docker run \
    -d \
    -p 80:80 \
    -p 443:443 \
    --restart=always \
    --name oc-server \
    --link oc-postgres:db \
    --volumes-from oc-data-files \
    oc-server
