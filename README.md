docker-owncloud
===============

Dockerfile for OwnCloud 7

OwnCloud version : `7.0.3`

# Setup

- Replace `db_root_password` and `db_user_password` in both `debconf` and
`db-owncloud.sql` files
- Add your SSL certificates in the current directory
(default filenames are `cert.key` and `cert.crt`)

# Build

    docker build -t owncloud .

# Run

    docker run -d -p 80:80 -p 443:443 owncloud

Moreover, you can export the OwnCloud `data` directory on the host with volume
binding :

    docker run -d -p 80:80 -p 443:443 "$(pwd)/data:/data" owncloud

with `$(pwd)/data` being the full path to your desired host data directory.
Also, don't forget to set `/data` as your data directory in the OwnCloud 
installation wizard.
