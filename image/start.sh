#!/bin/bash
echo "Starting..."
if [[ $PHP_MIN_WORKERS == "" ]]; then
	echo "Unable to read environment"
	exit 1
fi

# Setting php-fpm config
fpm_config=/etc/php/php-fpm.d/www.conf
sed -i "s/PHP_MIN_WORKERS/$PHP_MIN_WORKERS/g" "$fpm_config"
sed -i "s/PHP_MAX_WORKERS/$PHP_MAX_WORKERS/g" "$fpm_config"
if [[ $SITE_CHARSET != "" ]]; then
	sed -i "s/UTF-8/$SITE_CHARSET/g" /etc/php/php.ini
fi
if [[ $PHP_MAX_UPLOAD != "" ]]; then
	sed -i "s/20M/$PHP_MAX_UPLOAD/g" /etc/php/php.ini
fi
if [[ $PHP_MEMORY_LIMIT != "" ]]; then
	sed -i "s/128M/$PHP_MEMORY_LIMIT/g" /etc/php/php.ini
fi
if [[ $PHP_INPUT_TIME != "" ]]; then
	sed -i "s/= 400/= $PHP_INPUT_TIME/g" /etc/php/php.ini
fi
if [[ $PHP_EXECUTION_TIME != "" ]]; then
	sed -i "s/= 600/$PHP_EXECUTION_TIME/g" /etc/php/php.ini
fi
if [[ $PHP_FILE_UPLOADS != "" ]]; then
	sed -i "s/max_file_uploads = 20/max_file_uploads = $PHP_FILE_UPLOADS/g" /etc/php/php.ini
fi
echo "Starting PHP-FPM...."
php-fpm -D
echo "Starting lighttpd...."
lighttpd -D -f /etc/lighttpd/lighttpd.conf
