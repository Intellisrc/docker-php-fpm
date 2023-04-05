# Dockerfile for lighttpd
FROM alpine:3.6
EXPOSE 80
VOLUME ["/var/www"]

ENV PHP_MIN_WORKERS=1
ENV PHP_MAX_WORKERS=20
ENV PHP_VER=5

ENV TZ="Asia/Tokyo"
ENV ALPINE="v3.6"
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
	curl lighttpd \
	php$PHP_VER-fpm php$PHP_VER-ctype php$PHP_VER-common php$PHP_VER-intl \
	php$PHP_VER-curl php$PHP_VER-gd php$PHP_VER-json php$PHP_VER-mysqli \
	php$PHP_VER-zip php$PHP_VER-dom php$PHP_VER-iconv php$PHP_VER-opcache php$PHP_VER-exif && \
	rm -rf /var/cache/apk/*

COPY image/lighttpd.conf /etc/lighttpd/
COPY image/php-fpm.conf /etc/php$PHP_VER/php-fpm.d/www.conf
COPY image/php.ini /etc/php$PHP_VER/
COPY image/start.sh /usr/local/bin/
COPY image/ioncube_loader_lin_5.6.so /usr/lib/php5/modules/
COPY image/00-ioncube.ini /etc/php5/conf.d/

RUN mkdir -p /var/log/lighttpd/ && \
    mkdir -p /var/cache/lighttpd/uploads/ && \
    mkdir -p /var/cache/lighttpd/compress/ && \
	chown -R lighttpd.lighttpd /var/log/lighttpd/ && \
	chown -R lighttpd.lighttpd /var/cache/lighttpd/ && \
	ln -s /usr/sbin/php-fpm$PHP_VER /usr/sbin/php-fpm && \
	ln -s /etc/php$PHP_VER /etc/php && \
	ln -s /usr/bin/php-fpm$PHP_VER /usr/bin/php-fpm 

WORKDIR /var/www
CMD ["start.sh"]
