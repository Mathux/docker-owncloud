FROM ubuntu:latest
MAINTAINER mathieu.tarral@gmail.com

ENV DEBIAN_FRONTEND noninteractive
RUN (apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove --purge -y && apt-get clean -y)

# Commodities
#-------------------
RUN apt-get install -y bzip2 vim htop wget

# Debconf (mysql root password)
#---------------
ADD debconf /tmp/
RUN debconf-set-selections /tmp/debconf
RUN shred -f -n 0 -u -v -z /tmp/debconf

# Nginx
#---------------
RUN apt-get install -y nginx
COPY nginx-owncloud.conf /etc/nginx/sites-available/owncloud.conf
RUN cd /etc/nginx/sites-enabled/ && ln -s ../sites-available/owncloud.conf . \
    && rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
RUN mkdir -p /etc/ssl/nginx
ADD cert.crt /etc/ssl/nginx/
ADD cert.key /etc/ssl/nginx/
RUN chown www-data:www-data -R /etc/ssl/nginx

# Mysql
#----------------
RUN apt-get install -y mysql-server
# configure DB
ADD owncloud-db.sql /tmp/
RUN service mysql restart && mysql < /tmp/owncloud-db.sql
RUN shred -f -n 0 -u -v -z /tmp/owncloud-db.sql

# PHP5
#-----------------
RUN apt-get install -y php5 php5-fpm php5-mysql php5-gd php5-json php5-curl php5-gd php5-mcrypt php5-intl php5-ldap php5-imagick php5-apcu

# Owncloud
#----------------
RUN wget 'https://download.owncloud.org/community/owncloud-7.0.3.tar.bz2' -O /tmp/owncloud.tar.bz2 \
    && wget 'https://download.owncloud.org/community/owncloud-7.0.3.tar.bz2.sha256' -O /tmp/owncloud.sha256 \
    && wget 'https://download.owncloud.org/community/owncloud-7.0.3.tar.bz2.asc' -O /tmp/owncloud.tar.bz2.asc \
    && wget 'https://owncloud.org/owncloud.asc' -O /tmp/owncloud.asc \
    && gpg --import /tmp/owncloud.asc \
    && gpg --verify /tmp/owncloud.tar.bz2.asc \
    && sha256sum /tmp/owncloud.tar.bz2 | cut -d' ' -f1 > /tmp/owncloud.archive.sha256 \
    && cut -d' ' -f1 /tmp/owncloud.sha256 > /tmp/owncloud.archive.expected.sha256 \
    && diff /tmp/owncloud.archive.sha256 /tmp/owncloud.archive.expected.sha256 \
    && rm -f /tmp/owncloud.archive.sha256 /tmp/owncloud.archive.expected.sha256 /tmp/owncloud.tar.bz2.asc
RUN mkdir -p /var/www
RUN tar xjf /tmp/owncloud.tar.bz2 -C /var/www
RUN chown -R www-data:www-data /var/www/owncloud

VOLUME /data
RUN chown -R www-data:www-data /data

EXPOSE 80 443
# TODO : supervisor :)
CMD service php5-fpm start && service mysql start && service nginx start && chown www-data:www-data /data && while true; do sleep 1d; done
