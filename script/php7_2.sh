#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_php_7_2() {

PHPVERSION7="7.2"

install_packages "php$PHPVERSION7-dev php-auth-sasl php-imagick php-http-request php$PHPVERSION7-gd php$PHPVERSION7-bcmath php$PHPVERSION7-zip php-mail php-net-dime php-net-url php-pear php-apcu php$PHPVERSION7 php$PHPVERSION7-cli php$PHPVERSION7-common php$PHPVERSION7-curl php$PHPVERSION7-fpm php$PHPVERSION7-mysql php$PHPVERSION7-soap php$PHPVERSION7-sqlite3 php$PHPVERSION7-xsl php$PHPVERSION7-xmlrpc php-mbstring php-xml php$PHPVERSION7-json php$PHPVERSION7-opcache php$PHPVERSION7-readline php$PHPVERSION7-xml php$PHPVERSION7-mbstring php$PHPVERSION7-intl php-memcached"

cp ${SCRIPT_PATH}/configs/php/php.ini /etc/php/$PHPVERSION7/fpm/php.ini
cp ${SCRIPT_PATH}/configs/php/php-fpm.conf /etc/php/$PHPVERSION7/fpm/php-fpm.conf
cp ${SCRIPT_PATH}/configs/php/www.conf /etc/php/$PHPVERSION7/fpm/pool.d/www.conf

# Configure APCu
rm -rf /etc/php/$PHPVERSION7/mods-available/apcu.ini
rm -rf /etc/php/$PHPVERSION7/mods-available/20-apcu.ini

#überarbeiten
cp ${SCRIPT_PATH}/configs/php/apcu.ini /etc/php/$PHPVERSION7/mods-available/apcu.ini
sed -i "s/^expose_php = On/expose_php = Off/g" /etc/php/$PHPVERSION7/cli/php.ini

ln -s /etc/php/$PHPVERSION7/mods-available/apcu.ini /etc/php/$PHPVERSION7/mods-available/20-apcu.ini

systemctl -q restart nginx.service
systemctl -q restart php$PHPVERSION7-fpm.service
}
