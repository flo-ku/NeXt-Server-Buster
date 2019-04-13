#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------


install_mailserver() {

trap error_exit ERR

SCRIPT_PATH="/root/NeXt-Server-Buster"

cd /etc/nginx/ssl/
certbot certonly --webroot -w /var/www/${MYDOMAIN}/public/ -d mail.${MYDOMAIN} -d imap.${MYDOMAIN} -d smtp.${MYDOMAIN} -m ${NXT_SYSTEM_EMAIL} -n --agree-tos --test-cert
exit

MAILSERVER_DB_PASS=$(password)

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "MAILSERVER_DB_PASS: $MAILSERVER_DB_PASS" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt

sed -i "s/placeholder/${MAILSERVER_DB_PASS}/g" ${SCRIPT_PATH}/configs/mailserver/database.sql
mysql -u root -p${MYSQL_ROOT_PASS} mysql < ${SCRIPT_PATH}/configs/mailserver/database.sql

adduser --gecos "" --disabled-login --disabled-password --home /var/vmail vmail >>"${main_log}" 2>>"${err_log}"

mkdir -p /var/vmail/mailboxes
mkdir -p /var/vmail/sieve/global
chown -R vmail /var/vmail
chgrp -R vmail /var/vmail
chmod -R 770 /var/vmail

mysql -u root -p${MYSQL_ROOT_PASS} -e "use vmail; INSERT INTO domains (domain) values ('${MYDOMAIN}');"
}
