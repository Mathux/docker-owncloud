docker-owncloud
===============

Dockerfile for OwnCloud 8

OwnCloud version : `8.0.0

# Information

This setup will run OwnCloud in Docker, using the Data only containers pattern
for both files and database.

You will end up with the following Docker containers :

- `oc-data-files` : OwnCloud files (`owncloud/data` and `owncloud/config`)
- `oc-data-db` : OwnCloud Database (`/var/lib/prosgresql/data`)
- `oc-postgres` : Container running the Database (`Postgresql`)
- `oc-server` : Container running the server (`Apache2` on Fedora)

# Step 1 : Data only containers

    cd data/

build the image responsible for file storage and configuration :

    docker build -t oc-data-files .

then use `./run.sh` to create the Data only containers :

- `oc-data-files`
- `oc-data-db`

# Step 2 : Database setup

    cd db/

Edit `init-owncloud-postgres.sh` and configure the database credentials :

- `USERNAME`
- `PASSWORD`
- `DB`

Then build `oc-postgres` image :

    docker build -t oc-postgres .

And run it with `./run.sh`

# Step 3 : Run the server

Get back to the top of the repository, and build the `oc-server` image :

    docker build -t oc-server .

And use `./run.sh` to run the server !

# OwnCloud setup wizard

- select `postgresql` storage
- change `localhost` to `db` (`db` is the name you choose on the docker command line, when you want to link a container with another. here `--link oc-postgres:db`)

# References

- [OwnCloud in a container](http://www.herr-norbert.de/2014/10/04/docker-owncloud/)
