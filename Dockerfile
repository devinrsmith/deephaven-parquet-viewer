# syntax=docker/dockerfile:1.4

FROM ghcr.io/deephaven/server-slim:0.37.5
COPY --link config/ /opt/deephaven/config/
