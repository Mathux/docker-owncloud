#!/bin/bash

# Create Data only container for Files
docker run \
    --name oc-data-files \
    oc-data-files
# Create Data only container for DB
docker run \
    --name oc-data-db \
    -v /var/lib/postgresql/data \
    busybox \
    echo Data container Owncloud DB
