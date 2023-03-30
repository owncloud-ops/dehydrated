FROM docker.io/python:3.11-alpine@sha256:4b4078a3ab81edc2f5725cd42b065beaeeb4f9be3b4b1e3b4cf11dd6ae9720d3

LABEL maintainer="ownCloud GmbH"
LABEL org.opencontainers.image.authors="ownCloud GmbH"
LABEL org.opencontainers.image.title="dehydrated"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/dehydrated"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/dehydrated"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/dehydrated"

ARG CONTAINER_LIBRARY_VERSION
ARG LEXICON_VERSION
ARG DEHYDRATED_VERSION

# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ENV GOMPLATE_VERSION="${GOMPLATE_VERSION:-v3.11.4}"
# renovate: datasource=github-releases depName=owncloud-ops/container-library
ENV CONTAINER_LIBRARY_VERSION="${CONTAINER_LIBRARY_VERSION:-v0.1.0}"
# renovate: datasource=pypi depName=dns-lexicon
ENV LEXICON_VERSION="${LEXICON_VERSION:-3.11.7}"
# renovate: datasource=github-releases depName=dehydrated-io/dehydrated
ENV DEHYDRATED_VERSION="${DEHYDRATED_VERSION:-v0.7.1}"


ENV PY_COLORS=1 \
    PATH=/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin

ADD overlay/ /

RUN addgroup -g 1001 -S app && \
    adduser -S -D -H -u 1001 -h /opt/app/dehydrated -s /sbin/nologin -G app -g app app

RUN apk add --update --no-cache --virtual .build-deps build-base libffi-dev openssl-dev python3-dev curl && \
    apk add --update --no-cache bash sed gawk jq curl openssl grep diffutils coreutils bind-tools && \
    curl -SsfL "https://github.com/owncloud-ops/container-library/releases/download/${CONTAINER_LIBRARY_VERSION}/container-library.tar.gz" | tar xz -C / && \
    curl -SsfL -o /usr/local/bin/gomplate "https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64" && \
    chmod 755 /usr/local/bin/gomplate && \
    mkdir -p /opt/app/dehydrated/conf.d && \
    mkdir -p /opt/app/dehydrated/conf && \
    mkdir -p /opt/app/dehydrated/data && \
    echo "Installing requirements ..." && \
    pip install -qq --upgrade --no-cache-dir pip && \
    echo "Installing dehydrated 'v$DEHYDRATED_VERSION' ..." && \
    curl -SsfL "https://github.com/dehydrated-io/dehydrated/releases/download/${DEHYDRATED_VERSION}/dehydrated-${DEHYDRATED_VERSION##v}.tar.gz" | \
        tar xz --strip-component=1 -C /usr/local/bin "dehydrated-${DEHYDRATED_VERSION##v}/dehydrated" && \
    echo "Installing lexicon 'v$LEXICON_VERSION' ..." && \
    pip install -qq --no-cache-dir dns-lexicon=="$LEXICON_VERSION" && \
    chown -R app:app /opt/app/dehydrated && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /root/.cache/

USER app

ENTRYPOINT ["/usr/bin/entrypoint"]
WORKDIR "/opt/app/dehydrated"
CMD []
