# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:41.3
COPY --link config/ /opt/deephaven/config/
