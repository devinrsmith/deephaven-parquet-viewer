# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:43.0
COPY --link config/ /opt/deephaven/config/
