# php82 生成的 基础镜像
FROM registry.cn-beijing.aliyuncs.com/renkx/php:renkxdnmp-base-001

# todo 设置扩展数据
ADD ./services/extra  /home/www-data/extra

# todo 安装 supercronic
ENV SUPERCRONIC_URL=https://gitee.com/renkx/supercronic/releases/download/v0.2.2/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=2319da694833c7a147976b8e5f337cd83397d6be \
    # 设置composer 的 cache home
    COMPOSER_HOME=/tmp/composer \
    # 显式将默认 HOME 环境变量指向 /home/www-data
    HOME=/home/www-data

# 安装 composer
RUN curl -sS https://getcomposer.org/download/2.10.3/composer.phar -o /usr/bin/composer \
    && chmod +x /usr/bin/composer

# todo 安装 supercronic
RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    # 安装必要的软件（Debian 系统使用 apt-get 更新并安装 zsh、git、openssh-client、vim）
    && export option="--no-install-recommends -y" \
    && apt-get $option update \
    && apt-get $option install zsh git openssh-client vim \
    # 修改系统中 www-data 用户的默认家目录为 /home/www-data，并保持 shell 为 /bin/zsh 或 /bin/sh
    && usermod -d /home/www-data -s /bin/zsh www-data \
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
    && mkdir -p /etc/cron.d \
    && cp /home/www-data/extra/crontab /etc/cron.d/www-data \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /home/www-data/extra \
    # todo 最后需要删除zsh操作记录
    && rm -f /home/www-data/.zsh_history.new

# 工作目录
WORKDIR /www/wwwroot

# 设置用户
USER www-data

CMD ["/usr/local/bin/entrypoint"]