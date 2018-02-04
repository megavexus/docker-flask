FROM python:2.7-alpine
MAINTAINER Javier Gutiérrez "nexus.megavexus@gmail.com"

ENV INSTALL_PATH /flask_app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY requirements.txt requirements.txt

# This install the dependencies and remove the temporal and garbase data
# If you have more dependencies, you can put it in the second line, behind 'build-base'
RUN apk add --no-cache --virtual .build-deps \
    build-base \
        && pip install -r requirements.txt \
        && find /usr/local \
            \( -type d -a -name test -o -name tests \) \
            -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
            -exec rm -rf '{}' + \
        && runDeps="$( \
            scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
            )" \
        && apk add --virtual .rundeps $runDeps \
        && apk del .build-deps

COPY . .

EXPOSE 5000

# Script for install new dependencies
RUN printf "#!/bin/sh\npip install -r requirements.txt \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}'"  > /usr/bin/install_requirements && \
    chmod +x /usr/bin/install_requirements

ENTRYPOINT ["python"]
CMD ["app/__init__.py"]