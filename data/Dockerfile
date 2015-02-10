FROM busybox

MAINTAINER Norbert Schneider  <mail@herr-norbert.de>

RUN mkdir -p /var/www/html/owncloud/data
RUN chmod -R 0700 /var/www/html/owncloud/data
RUN chown -R 48:48 /var/www/html/owncloud/data
VOLUME ["/var/www/html/owncloud/data"]

RUN mkdir -p /var/www/html/owncloud/config
RUN chmod -R 0700 /var/www/html/owncloud/config
RUN chown -R 48:48 /var/www/html/owncloud/config
VOLUME ["/var/www/html/owncloud/config"]

CMD echo "Data container only (/data, /config)"
