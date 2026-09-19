# Dockerfile for lighttpd
FROM intellisrc/lighttpd:3.24
EXPOSE 80
VOLUME ["/var/www"]

ENV PHP_MIN_WORKERS=1
ENV PHP_MAX_WORKERS=20
ENV PHP_VER=84 
# PHP 8.5 is missing php*-opcache

# -------------- OS -----------------------
RUN apk add --update --no-cache \
	curl lighttpd \
	php$PHP_VER-fpm php$PHP_VER-ctype php$PHP_VER-common php$PHP_VER-intl \
	php$PHP_VER-curl php$PHP_VER-gd php$PHP_VER-json php$PHP_VER-mysqli php$PHP_VER-xml \
	php$PHP_VER-zip php$PHP_VER-dom php$PHP_VER-iconv php$PHP_VER-opcache php$PHP_VER-exif \
	php$PHP_VER-session php$PHP_VER-mbstring \
    php$PHP_VER-simplexml php$PHP_VER-xmlwriter \
	php$PHP_VER php$PHP_VER-fileinfo && \
	rm -rf /var/cache/apk/*

COPY image/lighttpd.conf /etc/lighttpd/
COPY image/php-fpm.conf /etc/php$PHP_VER/php-fpm.d/www.conf
COPY image/php.ini /etc/php$PHP_VER/
COPY image/start.sh /usr/local/bin/

RUN	ln -s /usr/sbin/php-fpm$PHP_VER /usr/sbin/php-fpm && \
	ln -s /etc/php$PHP_VER /etc/php && \
	ln -s /usr/bin/php-fpm$PHP_VER /usr/bin/php-fpm 

WORKDIR /var/www
CMD ["start.sh"]
