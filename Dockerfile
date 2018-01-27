FROM php:7.2-fpm

COPY php.ini /usr/local/etc/php/

WORKDIR /usr/src/myapp

COPY info.php /usr/src/myapp/

# https://github.com/docker/for-win/issues/1467#issuecomment-356753504
RUN set -xe \
    && apt-get update \
    && apt-get install -y iproute \
    && pecl install xdebug-2.6.0beta1 \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_host="`/sbin/ip route|awk '/default/ { print $3 }'` >> /usr/local/etc/php/php.ini \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80"]
