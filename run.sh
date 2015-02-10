#!/bin/bash

# Run OwnCloud
docker run \
    -d \
    --restart=always \
    --name owncloud \
    --link oc-postgres:db \
    --volumes-from oc-data-files \
    owncloud
