# Deephaven Parquet Viewer

A Parquet viewer powered by [deephaven-core](https://github.com/deephaven/deephaven-core). Supports opening and browsing through large (or small) parquet files.

![Deephaven Parquet Viewer](images/deephaven-parquet-viewer-example.png)

## Helper script

```
Usage: deephaven-parquet-viewer.sh [parquet-file]
```

## Docker container

```shell
docker run \
    --rm \
    --name deephaven-parquet-viewer \
    --mount type=bind,source=/path/to/file.parquet,target=/file.parquet,readonly \
    -p 10000:10000 \
    ghcr.io/devinrsmith/deephaven-parquet-viewer:latest
```
