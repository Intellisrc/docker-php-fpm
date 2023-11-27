#!/bin/bash
echo "Starting..."
if [[ $PHP_MIN_WORKERS == "" ]]; then
	echo "Unable to read environment"
	exit 1
fi

# Setting php-fpm config
fpm_config=/etc/php/php-fpm.conf
sed -i "s/PHP_MIN_WORKERS/$PHP_MIN_WORKERS/g" "$fpm_config"
sed -i "s/PHP_MAX_WORKERS/$PHP_MAX_WORKERS/g" "$fpm_config"
if [[ $SITE_CHARSET != "" ]]; then
	sed -i "s/UTF-8/$SITE_CHARSET/g" /etc/php5/php.ini
fi
echo "Starting PHP-FPM...."
php-fpm -D
echo "Starting lighttpd...."
lighttpd -D -f /etc/lighttpd/lighttpd.conf
