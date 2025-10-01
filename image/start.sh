#!/bin/bash
echo "Starting..."
if [[ $SITE_CHARSET != "" ]]; then
	sed -i "s/UTF-8/$SITE_CHARSET/g" /etc/php5/php.ini
fi
echo "Starting apache...."
httpd -X
