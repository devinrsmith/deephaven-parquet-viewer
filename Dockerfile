# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:0.33.3
COPY --link config/ /opt/deephaven/config/
