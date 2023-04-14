##### 构建 php81 镜像
```shell
docker build \
    --build-arg PHP_VERSION=php:8.1.17-cli-alpine3.17 \
    --build-arg CONTAINER_PACKAGE_URL=mirrors.aliyun.com \
    --build-arg PHP_EXTENSIONS=pdo_mysql,mysqli,mbstring,gd,curl,opcache,redis,bcmath,soap,xsl,xmlrpc,zip,pdo_dblib,pdo_sqlsrv,sockets,shmop,pcntl,gettext,mongodb,swoole \
    --build-arg TZ=Asia/Shanghai \
    --build-arg PHP_UID=1008 \
    --build-arg PHP_GID=1008 \
    -t registry.cn-beijing.aliyuncs.com/renkx/php:renkxdnmp-base-001 \
    -f ./services/php81/Dockerfile .
```

##### 构建 laravel 镜像
```shell
docker build -t registry.cn-beijing.aliyuncs.com/renkx/php:renkxdnmp-laravel-001 -f ./services/laravel/Dockerfile .
```