#!/usr/bin/env sh

set -e
# role http: api server
# role queue: message queue customer worker
# role horizon: message queue supervisor
# role cron: crontab worker
# role console: terminal console for cluster administrator
role=${CONTAINER_ROLE:-console}

# queue: message queue name
queue=${CONTAINER_QUEUE}

# queueMaxProcesses: horizon max queue processes
# value cover sequence: env > config > default(3)
queue_max_processes=${QUEUE_MAX_PROC}

# http_workers: number of HTTP server worker (most situation equal cpus)
http_workers=${HTTP_WORKERS:-2}

# task_workers: number of concurrently worker (most situation equal cpus)
task_workers=${TASK_WORKERS:-2}

# http_port: port of HTTP server
http_port=${HTTP_PORT:-80}

# http_max_request: max requests for reload workers
http_max_request=${HTTP_MAX_REQUEST:-0}

cd /www/wwwroot

echo
echo "start time：`date '+%Y-%m-%d %H:%M:%S'`"

# shellcheck disable=SC2039
if [[ "$role" = "http" ]]; then
    echo 'http starting ...'
    if [[ $http_max_request -gt 0 ]]; then
      exec /usr/local/bin/php /www/wwwroot/artisan octane:start --host=0.0.0.0 --port="$http_port" --workers="$http_workers" --task-workers="$task_workers" --max-requests="$http_max_request"
    else
      exec /usr/local/bin/php /www/wwwroot/artisan octane:start --host=0.0.0.0 --port="$http_port" --workers="$http_workers" --task-workers="$task_workers"
    fi
elif [[ "$role" = "cron" ]]; then
    echo "cron starting ..."
    exec supercronic /etc/crontabs/www-data
elif [[ "$role" = "queue" ]]; then
    echo "queue customer worker starting ..."
    exec /usr/local/bin/php /www/wwwroot/artisan queue:work --queue="$queue" --verbose
elif [[ "$role" = "horizon" ]]; then
    echo "horizon supervisor starting ..."
    if [[ "$queue" = "" && "$queue_max_processes" = "" ]]; then
        exec /usr/local/bin/php /www/wwwroot/artisan horizon --environment=production --verbose
    elif [[ "$queue_max_processes" = "" ]]; then
        exec /usr/local/bin/php /www/wwwroot/artisan horizon --environment=production --queue="$queue" --verbose
    elif [[ "$queue" = "" ]]; then
        exec /usr/local/bin/php /www/wwwroot/artisan horizon --environment=production --maxProcesses="$queue_max_processes" --verbose
    else
        exec /usr/local/bin/php /www/wwwroot/artisan horizon --environment=production --queue="$queue" --maxProcesses="$queue_max_processes" --verbose
    fi
else
    exec tail -f /usr/local/bin/entrypoint
fi

