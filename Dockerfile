FROM php:7.2-cli

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git wget curl openssh-client zip unzip \
        libcurl4-openssl-dev \
        libprotobuf-dev \
        protobuf-compiler \
        libbz2-dev \
        libpng-dev \
        libicu-dev \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libevent-dev \
        libssl-dev \
        libzip-dev \
    && docker-php-ext-install -j$(nproc) bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        intl \
        mysqli \
        pgsql \
        pdo_mysql \
        pdo_pgsql \
        soap \
        sockets \
        wddx \
        xsl \
        zip \
        opcache \
    && yes '' | pecl install -o memcached mcrypt-snapshot redis event xdebug apcu \
    && docker-php-ext-enable memcached mcrypt redis xdebug apcu \
    && docker-php-ext-enable event --ini-name zzz-docker-php-ext-event.ini \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require phpunit/phpunit:* \
    && composer global require phpmetrics/phpmetrics:* \
    && composer global require friendsofphp/php-cs-fixer:* \
    && ln -s ~/.composer/vendor/bin/phpunit /usr/local/bin/phpunit \
    && ln -s ~/.composer/vendor/bin/phpmetrics /usr/local/bin/phpmetrics \
    && ln -s ~/.composer/vendor/bin/php-cs-fixer /usr/local/bin/php-cs-fixer \
    && echo 'date.timezone = UTC' >> /usr/local/etc/php/conf.d/tz.ini \
    && echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/000_ci.ini