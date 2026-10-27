ARG PHP_VERSION
FROM ${PHP_VERSION}

ARG TZ
ARG PHP_EXTENSIONS
ARG DEBIAN_MIRROR_DOMAIN
ARG PHP_UID
ARG PHP_GID

ENV TZ=${TZ}

# Set debian mirror
RUN sed -i "s|deb.debian.org|${DEBIAN_MIRROR_DOMAIN}|g" /etc/apt/sources.list.d/debian.sources

# Install required packages
RUN export option="--no-install-recommends -y" \
    && apt-get $option update \
    && apt-get $option install tzdata curl passwd ffmpeg less tini

# Clean up the package list to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN curl -sSLf -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
&& chmod +x /usr/local/bin/install-php-extensions \
&& install-php-extensions $(echo "$PHP_EXTENSIONS" | tr ',' ' ')

# php image's www-data user uid & gid are 82, change them to 1000 (primary user)
RUN usermod -u $PHP_UID www-data \
    && groupmod -g $PHP_GID www-data \
    && mkdir -p /home/www-data \
    && chown -R www-data:www-data /home/www-data \
    && usermod -s /bin/sh www-data

ENV HOME=/home/www-data

# Set work directory
WORKDIR /www
RUN chown -R www-data:www-data /www

ENTRYPOINT ["tini", "--", "docker-php-entrypoint"]

CMD ["php", "-a"]