# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:0.27.1
COPY --link config/ /opt/deephaven/config/

# JVM heap for parquet reads. readTable is lazy (regioned on-demand loading),
# but heap must be bounded to avoid OOM on large files. Xms=Xmx eliminates heap
# resizing. The vmoptions file preserves the base image's G1GC settings; setting
# JAVA_OPTS directly would otherwise opt out of it.
ENV JAVA_OPTS="-Xmx4g -Xms4g -XX:VMOptionsFile=/opt/deephaven/server-jetty/etc/dh-default.vmoptions"
