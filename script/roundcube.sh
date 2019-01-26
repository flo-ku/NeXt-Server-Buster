#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_roundcube() {

trap error_exit ERR

mkdir -p /var/www/${MYDOMAIN}/public/webmail
cd /var/www/${MYDOMAIN}/public/
wget_tar "https://codeload.github.com/roundcube/roundcubemail/zip/${ROUNDCUBE_VERSION}"
unzip_file "${ROUNDCUBE_VERSION}"
mv /var/www/${MYDOMAIN}/public/roundcubemail-${ROUNDCUBE_VERSION}/ /var/www/${MYDOMAIN}/public/webmail/
rm /var/www/${MYDOMAIN}/public/${ROUNDCUBE_VERSION}
cd /var/www/${MYDOMAIN}/public/webmail
mv /var/www/${MYDOMAIN}/public/webmail/composer.json-dist /var/www/${MYDOMAIN}/public/webmail/composer.json
curl -sS https://getcomposer.org/installer | php && php composer.phar install --no-dev

chown root:root -R /var/www/${MYDOMAIN}/public/webmail
chmod 777 -R /var/www/${MYDOMAIN}/public/webmail/temp/
chmod 777 -R /var/www/${MYDOMAIN}/public/webmail/logs/

MYSQL_ROOT_PASS=$(grep -Pom 1 "(?<=^MYSQL_ROOT_PASS: ).*$" ${SCRIPT_PATH}/login_information.txt)
ROUNDCUBE_USER=$(username)
ROUNDCUBE_DB_PASS=$(password)
ROUNDCUBE_DB_NAME=$(username)

mysql -u root -p${MYSQL_ROOT_PASS} -e "CREATE DATABASE ${ROUNDCUBE_DB_NAME};"
mysql -u root -p${MYSQL_ROOT_PASS} -e "CREATE USER '${ROUNDCUBE_USER}'@'localhost' IDENTIFIED BY '${ROUNDCUBE_DB_PASS}';"
mysql -u root -p${MYSQL_ROOT_PASS} -e "GRANT ALL PRIVILEGES ON ${ROUNDCUBE_DB_NAME}.* TO '${ROUNDCUBE_USER}'@'localhost';"
mysql -u root -p${MYSQL_ROOT_PASS} -e "FLUSH PRIVILEGES;"

mysql -u root -p"${mysql_root_password}" '${ROUNDCUBE_DB_NAME}' < /var/www/${MYDOMAIN}/public/webmail/SQL/mysql.initial.sql

cp /var/www/${MYDOMAIN}/public/webmail/config.inc.php.sample /var/www/${MYDOMAIN}/public/webmail/config.inc.php

sed -i "s|^\(\$config\['db_dsnw'\] =\).*$|\1 \'mysqli://roundcube:${mysql_roundcube_password}@localhost/roundcube\';|" /var/www/${MYDOMAIN}/public/webmail/config/config.inc.php
sed -i "s|^\(\$config\['smtp_server'\] =\).*$|\1 \'localhost\';|" /var/www/${MYDOMAIN}/public/webmail/config/config.inc.php
sed -i "s|^\(\$config\['smtp_user'\] =\).*$|\1 \'%u\';|" /var/www/${MYDOMAIN}/public/webmail/config/config.inc.php
sed -i "s|^\(\$config\['smtp_pass'\] =\).*$|\1 \'%p\';|" /var/www/${MYDOMAIN}/public/webmail/config/config.inc.php

deskey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_#&!*%?' | fold -w 24 | head -n 1)
sed -i "s|^\(\$config\['des_key'\] =\).*$|\1 \'${deskey}\';|" /var/www/html/roundcube/config/config.inc.php

rm -rf /var/www/html/roundcube/installer

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "Roundcube Webmail URL: https://${MYDOMAIN}/webmail/" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt
}
