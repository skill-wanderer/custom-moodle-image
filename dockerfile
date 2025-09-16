FROM bitnami/moodle:5.0.2

USER root
RUN install_packages php-pear php-dev build-essential \
    && pecl install redis \
    && echo "extension=redis.so" > /opt/bitnami/php/etc/conf.d/redis.ini \
    && rm -rf /tmp/pear
