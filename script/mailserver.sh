#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------


install_mailserver() {

trap error_exit ERR

SCRIPT_PATH="/root/NeXt-Server-Buster"

systemctl -q stop nginx.service
cd ${SCRIPT_PATH}/sources/acme.sh/
bash acme.sh --issue --debug 2 --standalone -d mail.${MYDOMAIN} -d imap.${MYDOMAIN} -d smtp.${MYDOMAIN} --keylength 4096 >>"${main_log}" 2>>"${err_log}"
ln -s /root/.acme.sh/mail.${MYDOMAIN}/fullchain.cer /etc/nginx/ssl/mail.${MYDOMAIN}.cer
ln -s /root/.acme.sh/mail.${MYDOMAIN}/mail.${MYDOMAIN}.key /etc/nginx/ssl/mail.${MYDOMAIN}.key
systemctl -q start nginx.service

MAILSERVER_DB_PASS=$(password)

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "MAILSERVER_DB_PASS: $MAILSERVER_DB_PASS" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt

sed -i "s/placeholder/${MAILSERVER_DB_PASS}/g" ${SCRIPT_PATH}/configs/mailserver/database.sql
mysql -u root -p${MYSQL_ROOT_PASS} mysql < ${SCRIPT_PATH}/configs/mailserver/database.sql

mysql -u root -p${MYSQL_ROOT_PASS} mysql < ${SCRIPT_PATH}/configs/mailserver/tlspolicies.sql

adduser --gecos "" --disabled-login --disabled-password --home /var/vmail vmail >>"${main_log}" 2>>"${err_log}"

mkdir -p /var/vmail/mailboxes
mkdir -p /var/vmail/sieve/global
chown -R vmail /var/vmail
chgrp -R vmail /var/vmail
chmod -R 770 /var/vmail

mysql -u root -p${MYSQL_ROOT_PASS} -e "use vmail; INSERT INTO domains (domain) values ('${MYDOMAIN}');"
}