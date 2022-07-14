# syntax=docker/dockerfile:1.4

FROM busybox as deephaven-app
ARG DEEPHAVEN_VERSION="0.14.0"
ARG DEEPHAVEN_SHA256SUM="d358b0f0945a7cd183f045a9fd72ff5c7dcb94e485c190f65b981ae65c4044ce"
ADD --link https://github.com/deephaven/deephaven-core/releases/download/v${DEEPHAVEN_VERSION}/server-jetty-${DEEPHAVEN_VERSION}.tar .
RUN set -eux; \
    echo "${DEEPHAVEN_SHA256SUM}  server-jetty-${DEEPHAVEN_VERSION}.tar" | sha256sum -c -; \
    mkdir -p /opt/deephaven; \
    tar -xf server-jetty-${DEEPHAVEN_VERSION}.tar -C /opt/deephaven; \
    ln -s /opt/deephaven/server-jetty-${DEEPHAVEN_VERSION} /opt/deephaven/server-jetty

FROM eclipse-temurin:17
COPY --link --from=deephaven-app /opt/deephaven /opt/deephaven
COPY --link config/ /opt/deephaven/config/
VOLUME /data
VOLUME /cache
EXPOSE 10000
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:10000 || exit 1
ENTRYPOINT [ "/opt/deephaven/server-jetty/bin/start", "/opt/deephaven/config/image-bootstrap.properties" ]
