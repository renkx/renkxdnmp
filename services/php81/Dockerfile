ARG PHP_VERSION
FROM ${PHP_VERSION}

ARG TZ
ARG PHP_EXTENSIONS
ARG CONTAINER_PACKAGE_URL
ARG PHP_UID
ARG PHP_GID

RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

COPY ./services/php81/extensions /tmp/extensions
WORKDIR /tmp/extensions
RUN chmod +x install.sh \
    && sh install.sh \
    && rm -rf /tmp/extensions

RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone

# Fix: https://github.com/docker-library/php/issues/240
RUN apk add gnu-libiconv libstdc++ --no-cache --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# php image's www-data user uid & gid are 82, change them to 1000 (primary user)
RUN apk --no-cache add shadow && usermod -u $PHP_UID www-data && groupmod -g $PHP_GID www-data && chown -R www-data:www-data /home/www-data

# todo 安装 ffmpeg 等
# todo less解决BusyBox异常：https://github.com/pry/pry/issues/1248
RUN apk --no-cache add ffmpeg less tini \
	&& rm -rf /var/cache/apk/* \
    # todo 更改用户shell www-data需要执行定时脚本
    && usermod -s /bin/ash www-data

# 工作目录
WORKDIR /

ENTRYPOINT ["/sbin/tini", "--", "docker-php-entrypoint"]

CMD ["php", "-a"]