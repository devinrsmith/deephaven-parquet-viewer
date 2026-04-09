# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:41.5
COPY --link config/ /opt/deephaven/config/
