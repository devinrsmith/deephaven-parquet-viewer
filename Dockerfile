# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:0.36.0
COPY --link config/ /opt/deephaven/config/
