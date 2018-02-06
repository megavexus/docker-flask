#!/bin/sh
if [ ! -f /debug0 ]; then
	if [ -e requirements_image.txt ]; then
		apk add --no-cache $(cat requirements_image.txt) && \
         runDeps="$( \
            scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
            )" \
         && apk add --virtual .rundeps $runDeps \
         && apk del .build-deps
	fi

	if [ -e requirements.txt ]; then
		pip install -r requirements.txt \
            &&  find /usr/local \
            \( -type d -a -name test -o -name tests \) \
            -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
            -exec rm -rf '{}'
	fi
fi

if [ -e /debug1 ]; then
 	echo "Running app in debug mode!"
else
 	echo "Running app in production mode!"
fi

python $APP_FILE_MAIN
