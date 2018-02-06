FROM python:2.7-alpine
MAINTAINER Javier Gutiérrez "nexus.megavexus@gmail.com"

# Set up the environment variables of paths
ENV APP_DIR /flask_app
ENV APP_FILE_MAIN app/__init__.py

# This install the basic and common dependencies
# and remove the temporal and garbase data
RUN apk add --no-cache --virtual .build-deps \
    build-base musl-dev linux-headers gcc g++\
    && runDeps="$( \
    scanelf --needed --nobanner --recursive /usr/local \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u \
    | xargs -r apk info --installed \
    | sort -u \
    )" \
    && apk add --virtual .rundeps $runDeps \
    && apk del .build-deps

# craete and mount the app directory
RUN mkdir -p $APP_DIR
VOLUME [${APP_DIR}]
WORKDIR $APP_DIR

# Script for install new python/flask dependencies
RUN printf "#!/bin/sh\n \
    pip install -r requirements.txt \
    && find /usr/local \
    \( -type d -a -name test -o -name tests \) \
    -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    -exec rm -rf '{}'"  \
    > /usr/bin/install_requirements && \
    chmod +x /usr/bin/install_requirements

# Script for install new alpine packages
RUN printf "#!/bin/sh\n \
    apk add --no-cache --virtual .build-deps $(cat requirements_image.txt) \
    && runDeps=\"$( \
    scanelf --needed --nobanner --recursive /usr/local \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u \
    | xargs -r apk info --installed \
    | sort -u \
    )\" \
    && apk add --virtual .rundeps $runDeps \
    && apk del .build-deps"  \
    > /usr/bin/install_packages && \
    chmod +x /usr/bin/install_packages

COPY entrypoint.sh /entrypoint.sh
RUN chmod ug+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]