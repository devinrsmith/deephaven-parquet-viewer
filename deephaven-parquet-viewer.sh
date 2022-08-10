#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

PARQUET_FILE="${1:-}"
PORT="${2:-10000}"
CONTAINER_NAME="${CONTAINER_NAME:-deephaven-parquet-viewer}"
REPO_PREFIX="${REPO_PREFIX:-ghcr.io/devinrsmith/}"

function cleanup {
  docker stop ${CONTAINER_NAME} > /dev/null
}

function pwdpath {
    [[ $1 = /* ]] && echo "$1" || echo "${PWD}/${1#./}"
}

if [ -z "${PARQUET_FILE}" ]; then
    echo "Usage: $0 [parquet-file]"
    exit 0
elif [ ! -f "${PARQUET_FILE}" ]; then
    echo "Argument is not a file"
    exit 1
fi

docker run \
    --rm \
    -d \
    --name ${CONTAINER_NAME} \
    -p "$PORT:10000" \
    --mount type=bind,source=$(pwdpath "${PARQUET_FILE}"),target=/file.parquet,readonly \
    ${REPO_PREFIX}deephaven-parquet-viewer:latest > /dev/null

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
