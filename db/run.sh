#!/bin/bash

# Run OwnCloud DB (Postgres)
docker run \
    -d \
    --restart=always \
    --name oc-postgres \
    --volumes-from oc-data-db \
    oc-postgres
