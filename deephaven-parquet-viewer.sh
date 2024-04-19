#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -x

PARQUET_SOURCE="${1:-}"
PORT="${2:-10000}"
CONTAINER_NAME="${CONTAINER_NAME:-deephaven-parquet-viewer}"
REPO_PREFIX="${REPO_PREFIX:-ghcr.io/devinrsmith/}"

function cleanup {
  docker stop ${CONTAINER_NAME} > /dev/null
}

function pwdpath {
    [[ $1 = /* ]] && echo "$1" || echo "${PWD}/${1#./}"
}

if [ -z "${PARQUET_SOURCE}" ]; then
    echo "Usage: $0 [parquet-source]"
    exit 0
fi

if [[ "${PARQUET_SOURCE}" == s3:* ]]; then
    docker run \
        --name ${CONTAINER_NAME} \
        --rm \
        -d \
        -p "$PORT:10000" \
        -e PARQUET_SOURCE="${PARQUET_SOURCE}" \
        -e AWS_REGION \
        -e AWS_DEFAULT_REGION \
        -e AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY \
        -e AWS_ENDPOINT_URL \
        ${REPO_PREFIX}deephaven-parquet-viewer:latest > /dev/null
elif [ ! -f "${PARQUET_SOURCE}" ]; then
    echo "Argument is not a file nor S3 URI"
    exit 1
else
    docker run \
        --name ${CONTAINER_NAME} \
        --rm \
        -d \
        -p "$PORT:10000" \
        -e PARQUET_SOURCE=file:///file.parquet \
        --mount type=bind,source=$(pwdpath "${PARQUET_SOURCE}"),target=/file.parquet,readonly \
        ${REPO_PREFIX}deephaven-parquet-viewer:latest > /dev/null
fi

trap cleanup EXIT

echo -n "Starting Deephaven Parquet Viewer"

while [ "$(docker inspect -f {{.State.Health.Status}} ${CONTAINER_NAME})" != "healthy" ]
do
    echo -n "."
    sleep 1
done
echo
echo "Ready!"
echo "table @ http://localhost:$PORT/iframe/table/?name=parquet_table"
echo "ide @ http://localhost:$PORT/ide/"
echo
echo "Control-C to exit"
read -r -d '' _ </dev/tty
