FROM php:8.2-cli-alpine as build
#
RUN apk update && apk upgrade
RUN apk add --no-cache $PHPIZE_DEPS
RUN docker-php-ext-enable sodium
RUN wget -O /usr/local/bin/composer https://getcomposer.org/composer-2.phar \
    && chmod 755 /usr/local/bin/composer
RUN cd /opt \
    && /usr/local/bin/composer init --name 'tybw/php-insights' --require nunomaduro/phpinsights:^2.8 \
    && /usr/local/bin/composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true \
    && /usr/local/bin/composer install
RUN mkdir -p /app
ENV COMPOSER_ALLOW_SUPERUSER=1
WORKDIR /app
ENTRYPOINT ["/opt/vendor/nunomaduro/phpinsights/bin/phpinsights"]
