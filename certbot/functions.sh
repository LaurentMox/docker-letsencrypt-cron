#!/usr/bin/env bash
# From https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion/blob/master/app/functions.sh
## Docker API
function docker_api {
    local scheme
    local curl_opts=(-s)
    local method=${2:-GET}
    # data to POST
    if [[ -n "${3:-}" ]]; then
        curl_opts+=(-d "$3")
    fi
    if [[ -z "$DOCKER_HOST" ]];then
        echo "Error DOCKER_HOST variable not set" >&2
        return 1
    fi
    if [[ $DOCKER_HOST == unix://* ]]; then
        curl_opts+=(--unix-socket ${DOCKER_HOST#unix://})
        scheme='http://localhost'
    else
        scheme="http://${DOCKER_HOST#*://}"
    fi
    [[ $method = "POST" ]] && curl_opts+=(-H 'Content-Type: application/json')
    curl "${curl_opts[@]}" -X${method} ${scheme}$1
}

function docker_exec {
    local id="${1?missing id}"
    local cmd="${2?missing command}"
    local data=$(printf '{ "AttachStdin": false, "AttachStdout": true, "AttachStderr": true, "Tty":false,"Cmd": %s }' "$cmd")
    exec_id=$(docker_api "/containers/$id/exec" "POST" "$data" | jq -r .Id)
    if [[ -n "$exec_id" ]]; then
        docker_api /exec/$exec_id/start "POST" '{"Detach": false, "Tty":false}'
    fi
}

function docker_kill {
    local id="${1?missing id}"
    local signal="${2?missing signal}"
    docker_api "/containers/$id/kill?signal=$signal" "POST"
}

## Nginx
reload_nginx() {
    if [[ -n "${NGINX_PROXY_CONTAINER:-}" ]]; then
        echo "Reloading nginx (using separate container ${NGINX_PROXY_CONTAINER})..."
        docker_kill "$NGINX_PROXY_CONTAINER" SIGHUP
    fi
}