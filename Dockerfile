# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:0.24.0
COPY --link config/ /opt/deephaven/config/
ENV START_OPTS="-Ddeephaven.application.dir=/opt/deephaven/config/app.d"
