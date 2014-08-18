FROM ubuntu:14.04
MAINTAINER mathieu.tarral@gmail.com

# ENV DEBIAN_FRONTEND noninteractive
RUN (apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove --purge -y && apt-get clean -y)

# Dependencies
#---------------
# debconf selections
# ADD debconf /tmp/
# RUN debconf-set-selections /tmp/debconf
# Server : apache2
RUN apt-get install -y apache2
# DB : MySQL
RUN apt-get install -y mysql-server
# configure DB
ADD owncloud-db.sql /tmp/
RUN service mysql restart && mysql < /tmp/owncloud-db.sql
# PHP5
RUN apt-get install -y php5 php5-mysql php5-gd php5-json php5-curl php5-gd php5-mcrypt php5-intl php5-ldap php5-imagick php5-apcu

# General
RUN apt-get install -y bzip2 vim htop wget

# Owncloud
#----------------
RUN wget 'https://download.owncloud.org/community/owncloud-7.0.1.tar.bz2' -O /tmp/owncloud.tar.bz2
RUN wget 'https://download.owncloud.org/community/owncloud-7.0.1.tar.bz2.sha256' -O /tmp/owncloud.sha256
RUN wget 'https://download.owncloud.org/community/owncloud-7.0.1.tar.bz2.asc' -O /tmp/owncloud.tar.bz2.asc
RUN wget 'https://owncloud.org/owncloud.asc' -O /tmp/owncloud.asc
RUN gpg --import /tmp/owncloud.asc
RUN gpg --verify /tmp/owncloud.tar.bz2.asc 
# RUN sha256sum /tmp/owncloud.tar.bz2 | diff /tmp/owncloud.sha256 -
RUN tar xjf /tmp/owncloud.tar.bz2 -C /var/www
RUN chown -R www-data:www-data /var/www/owncloud

# Apache Site config
#-----------------
RUN a2dissite 000-default
ADD owncloud.conf /etc/apache2/sites-available/
RUN a2ensite owncloud
RUN a2enmod rewrite ssl


# Reload Apache2
#-----------------
RUN service apache2 restart

EXPOSE 22
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]
