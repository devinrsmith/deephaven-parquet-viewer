# Deephaven Parquet Viewer

A Parquet viewer powered by [deephaven-core](https://github.com/deephaven/deephaven-core). Supports opening and browsing through large (or small) parquet files and S3 URIs.

![Deephaven Parquet Viewer](images/deephaven-parquet-viewer-example.png)

## Helper script

```
Usage: deephaven-parquet-viewer.sh [parquet-source] ([port])
```

## Examples

```shell
deephaven-parquet-viewer.sh /path/to/file.parquet
```

```shell
deephaven-parquet-viewer.sh s3://ookla-open-data/parquet/performance/type=fixed/year=2022/quarter=4/2022-10-01_performance_fixed_tiles.parquet
```

```shell
deephaven-parquet-viewer.sh s3://ookla-open-data/parquet/performance/
```

### For file

```shell
docker run \
    --rm \
    -p 10000:10000 \
    --mount type=bind,source=/path/to/file.parquet,target=/file.parquet,readonly \
    ghcr.io/devinrsmith/deephaven-parquet-viewer:latest
```

### For S3

```shell
docker run \
    --rm \
    -p 10000:10000 \
    -e PARQUET_SOURCE=s3://ookla-open-data/parquet/performance/type=fixed/year=2022/quarter=4/2022-10-01_performance_fixed_tiles.parquet \
    ghcr.io/devinrsmith/deephaven-parquet-viewer:latest
```

```shell
docker run \
    --rm \
    -p 10000:10000 \
    -e PARQUET_SOURCE=s3://ookla-open-data/parquet/performance/ \
    ghcr.io/devinrsmith/deephaven-parquet-viewer:latest
```

The S3 configuration also allows the passthrough of common [AWS CLI environment variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html), specifically `AWS_REGION`, `AWS_DEFAULT_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_ENDPOINT_URL`.
For example, to connect to [Backblaze B2 drive stats](https://www.backblaze.com/docs/cloud-storage-use-snowflake-to-query-existing-data-in-backblaze-b2):

```shell
docker run \
    --rm \
    -p 10000:10000 \
    -e PARQUET_SOURCE=s3://drivestats-parquet/drivestats/ \
    -e AWS_REGION=us-west-004 \
    -e AWS_ACCESS_KEY_ID=0045f0571db506a0000000007 \
    -e AWS_SECRET_ACCESS_KEY=K004cogT4GIeHHfhCyPPLsPBT4NyY1A \
    -e AWS_ENDPOINT_URL=https://s3.us-west-004.backblazeb2.com \
    ghcr.io/devinrsmith/deephaven-parquet-viewer:latest
```

## Browser

 * Table iframe: [http://localhost:10000/iframe/table/?name=parquet_table](http://localhost:10000/iframe/table/?name=parquet_table)
 * IDE: [http://localhost:10000/ide/](http://localhost:10000/ide/)

## Requirements

Linux, Mac OS (Intel or M1), and Windows WSL should all be supported. Docker is currently a requirement for running the helper script and via a Docker container, but advanced users can get the application running natively if desired.
