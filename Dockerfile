# Dockerfile for Apache PHP
FROM alpine:3.8
EXPOSE 80
VOLUME ["/var/www"]

ENV PHP_MIN_WORKERS=1
ENV PHP_MAX_WORKERS=20
ENV PHP_VER=5

ENV TZ="Asia/Tokyo"
ENV ALPINE="v3.8"
ENV CUSTOM_REP="http://ftp.tsukuba.wide.ad.jp/Linux/alpine"

# -------------- OS -----------------------
RUN { \
    echo "$CUSTOM_REP/$ALPINE/main/" ; \
    echo "$CUSTOM_REP/$ALPINE/community/" ; \
    echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE/main" ; \
    echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE/community" ; \
    } >/etc/apk/repositories

RUN echo "Setting Time Zone to: $TZ" && \
	apk update && \
	apk upgrade && \
	apk add --no-cache bash tzdata ca-certificates && \
    cp "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo "$TZ" > /etc/timezone && \
    apk del tzdata && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

RUN apk add --update --no-cache \
	curl apache2 php$PHP_VER-apache2 \
	php$PHP_VER-ctype php$PHP_VER-common php$PHP_VER-intl \
	php$PHP_VER-curl php$PHP_VER-gd php$PHP_VER-json php$PHP_VER-mysqli \
    php$PHP_VER-xml php$PHP_VER-xmlreader php$PHP_VER-xmlrpc \
	php$PHP_VER-zip php$PHP_VER-dom php$PHP_VER-iconv php$PHP_VER-opcache php$PHP_VER-exif && \
	rm -rf /var/cache/apk/*

COPY image/httpd.conf /etc/apache2/httpd.conf
COPY image/php.ini /etc/php$PHP_VER/
COPY image/start.sh /usr/local/bin/

RUN mkdir /var/apache2
RUN mkdir /run/apache2

RUN ln -s /usr/lib/apache2 /var/apache2/modules
RUN ln -s /var/log/apache2 /var/apache2/logs

RUN	ln -s /etc/php$PHP_VER /etc/php

WORKDIR /var/www
CMD ["start.sh"]
