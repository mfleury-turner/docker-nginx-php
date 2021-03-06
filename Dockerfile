# NAME: nginx-php
# Basic Nginx PHP-FPM Build
FROM alpine:3.5
COPY repositories /etc/apk/repositories
#Environment

RUN apk update \
 && apk upgrade \
 && apk add \
    autoconf \
    bash \
    ca-certificates \
    curl \
    g++ \
    git \
    libressl \
    make \
    musl \
    musl-dev \
    musl-utils \
    nginx \
    libwebp \
    php7@community \
    php7-apcu@community \
    php7-dom@community \
    php7-fpm@community \
    php7-openssl@community \
    php7-mcrypt@community \
    php7-zlib@community \
    php7-ctype@community \
    php7-curl@community \
    php7-bz2@community \
    php7-gd@community \
    php7-iconv@community \
    php7-json@community \
    php7-mbstring@community \
    php7-mysqli@community \
    php7-opcache@community \
    php7-openssl@community \
    php7-pdo@community \
    php7-pdo_mysql@community \
    php7-phar@community \
    php7-session@community \
    php7-xdebug@community \
    shadow@community \
    tar \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/* \
 && ln -s /usr/bin/php7 /usr/bin/php

COPY redis.so /usr/lib/php7/modules/redis.so
RUN bash -c "echo extension=redis.so > /etc/php7/conf.d/redis.ini"


# Install Composer
RUN mkdir -p /etc/ssl/certs/ \
 && update-ca-certificates --fresh \
 && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

#install newrelic php agent and daemon
ENV NR_INSTALL_SILENT=FALSE
ENV NR_INSTALL_KEY=${}
ENV NR_INSTALL_USE_CP_NOT_LN=/usr/bin/newrelic-php/
ENV NR_INSTALL_PATH=/newrelic-php5-6.5.0.166-linux-musl
RUN wget "http://download.newrelic.com/php_agent/archive/6.5.0.166/newrelic-php5-6.5.0.166-linux-musl.tar.gz" \
 && gzip -dc newrelic-php5-6.5.0.166-linux-musl.tar.gz | tar xf - \
 && cd newrelic-php5-6.5.0.166-linux-musl \
 && ./newrelic-install install \
 && rm -rf /newrelic-php5-6.5.0.166-linux-musl \
 && rm -rf /newrelic-php5-6.5.0.166-linux-musl.tar.gz \
 && mkdir -p /var/log/newrelic \
 && mkdir -p /var/run/newrelic

# Ensure $HOME is set
ENV HOME /root
# Create www-data user
RUN adduser -S www-data -G www-data \
 && usermod -u 1000 www-data
