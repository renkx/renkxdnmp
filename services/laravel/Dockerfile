# php81 生成的 基础镜像
FROM registry.cn-beijing.aliyuncs.com/renkx/php:renkxdnmp-base-001

# todo 设置扩展数据
ADD ./services/extra  /home/www-data/extra

    # todo 安装 supercronic
ENV SUPERCRONIC_URL=https://gitee.com/renkx/supercronic/releases/download/v0.2.2/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=2319da694833c7a147976b8e5f337cd83397d6be \
    # 设置composer 的 cache home
    COMPOSER_HOME=/tmp/composer

    # 安装composer
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/bin/composer \
    # todo 安装 supercronic
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    # 安装必要的软件
    && apk update \
    && apk --no-cache add zsh git openssh vim \
    # oh-my-zsh 安装
    && git clone https://gitee.com/renkx/ohmyzsh.git /home/www-data/.oh-my-zsh \
    && mv /home/www-data/extra/zshrc /home/www-data/.zshrc \
    && mkdir /home/www-data/.ssh \
    && mv /home/www-data/extra/gitconfig /home/www-data/.gitconfig \
    && chown -R www-data:www-data /home/www-data \
    && chmod 700 /home/www-data/.ssh \
    && chmod 644 /home/www-data/.gitconfig \
    && git clone --depth=1 https://gitee.com/StupidYan/zsh-autosuggestions.git /home/www-data/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone --depth=1 https://gitee.com/tan00/zsh-syntax-highlighting.git /home/www-data/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    # 处理php配置
    && mv /home/www-data/extra/php/php.ini /usr/local/etc/php/php.ini \
    # 处理启动脚本
    && mv /home/www-data/extra/entrypoint.sh /usr/local/bin/entrypoint \
    && chmod 755 /usr/local/bin/entrypoint \
    # 处理定时任务
    && cp /home/www-data/extra/crontab /etc/crontabs/www-data \
    && rm -rf /var/cache/apk/* /home/www-data/extra \
    # todo 最后需要删除zsh操作记录
    && rm -f /home/www-data/.zsh_history.new

# 工作目录
WORKDIR /www/wwwroot

# 设置用户
USER www-data

CMD ["/usr/local/bin/entrypoint"]