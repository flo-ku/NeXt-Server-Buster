#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_lets_encrypt() {

trap error_exit ERR

systemctl -q stop nginx.service
mkdir -p /etc/nginx/ssl/

install_packages "cron netcat-openbsd curl socat"
cd ${SCRIPT_PATH}/sources
git clone https://github.com/Neilpang/acme.sh.git -q >>"${main_log}" 2>>"${err_log}"
cd ./acme.sh
sleep 1
./acme.sh --install --accountemail ${NXT_SYSTEM_EMAIL} >>"${main_log}" 2>>"${err_log}"

. ~/.bashrc >>"${main_log}" 2>>"${err_log}"
. ~/.profile >>"${main_log}" 2>>"${err_log}"
}

create_nginx_cert() {

systemctl -q stop nginx.service

cd ${SCRIPT_PATH}/sources/acme.sh/
bash acme.sh --issue --standalone --debug 2 --log -d ${MYDOMAIN} -d www.${MYDOMAIN} --keylength ec-384 --staging >>"${main_log}" 2>>"${err_log}"

ln -s /root/.acme.sh/${MYDOMAIN}_ecc/fullchain.cer /etc/nginx/ssl/${MYDOMAIN}-ecc.cer >>"${main_log}" 2>>"${err_log}"
ln -s /root/.acme.sh/${MYDOMAIN}_ecc/${MYDOMAIN}.key /etc/nginx/ssl/${MYDOMAIN}-ecc.key >>"${main_log}" 2>>"${err_log}"

HPKP1=$(openssl x509 -pubkey < /etc/nginx/ssl/${MYDOMAIN}-ecc.cer | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64) >>"${main_log}" 2>>"${err_log}"
HPKP2=$(openssl rand -base64 32) >>"${main_log}" 2>>"${err_log}"

#SED doesn't work when the HPKP contains "/", so we escape it
HPKP1=$(echo "$HPKP1" | sed 's/\//\\\//g')
HPKP2=$(echo "$HPKP2" | sed 's/\//\\\//g')

sed -i "s/HPKP1/${HPKP1}/g" /etc/nginx/_general.conf
sed -i "s/HPKP2/${HPKP2}/g" /etc/nginx/_general.conf

sed -i 's/HPKP1="1"/HPKP1="${HPKP1}"/' ${SCRIPT_PATH}/configs/userconfig.cfg
sed -i 's/HPKP2="2"/HPKP2="${HPKP2}"/' ${SCRIPT_PATH}/configs/userconfig.cfg

### change path --> see system.sh
echo "0 0 1 */3 *"   root    bash /etc/cron.d/le_cert_alert >> /etc/crontab
}

update_nginx_cert() {

SCRIPT_PATH="/root/NeXt-Server-Buster"

source ${SCRIPT_PATH}/configs/versions.cfg
source ${SCRIPT_PATH}/configs/userconfig.cfg	

systemctl -q stop nginx.service

#cleanup old cert / key, maybe backup until success?
rm -R /root/.acme.sh/${MYDOMAIN}_ecc/
rm /etc/nginx/ssl/${MYDOMAIN}-ecc.cer
rm /etc/nginx/ssl/${MYDOMAIN}-ecc.key

#delete old keys
sed -i 's/HPKP1="'${HPKP1}'"/HPKP1="1"/' ${SCRIPT_PATH}/configs/userconfig.cfg
sed -i 's/HPKP2="'${HPKP2}'"/HPKP2="2"/' ${SCRIPT_PATH}/configs/userconfig.cfg

cd ${SCRIPT_PATH}/sources/acme.sh/
bash acme.sh --issue --standalone --debug 2 --log -d ${MYDOMAIN} -d www.${MYDOMAIN} --keylength ec-384 --staging >>"${main_log}" 2>>"${err_log}"

ln -s /root/.acme.sh/${MYDOMAIN}_ecc/fullchain.cer /etc/nginx/ssl/${MYDOMAIN}-ecc.cer >>"${main_log}" 2>>"${err_log}"
ln -s /root/.acme.sh/${MYDOMAIN}_ecc/${MYDOMAIN}.key /etc/nginx/ssl/${MYDOMAIN}-ecc.key >>"${main_log}" 2>>"${err_log}"

HPKP1=$(openssl x509 -pubkey < /etc/nginx/ssl/${MYDOMAIN}-ecc.cer | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64) >>"${main_log}" 2>>"${err_log}"
HPKP2=$(openssl rand -base64 32) >>"${main_log}" 2>>"${err_log}"

#SED doesn't work when the HPKP contains "/", so we escape it
HPKP1=$(echo "$HPKP1" | sed 's/\//\\\//g')
HPKP2=$(echo "$HPKP2" | sed 's/\//\\\//g')

sed -i "s/HPKP1/${HPKP1}/g" /etc/nginx/_general.conf
sed -i "s/HPKP2/${HPKP2}/g" /etc/nginx/_general.conf

sed -i 's/HPKP1="1"/HPKP1="'${HPKP1}'"/' ${SCRIPT_PATH}/configs/userconfig.cfg
sed -i 's/HPKP2="2"/HPKP2="'${HPKP2}'"/' ${SCRIPT_PATH}/configs/userconfig.cfg

systemctl -q start nginx.service
}

update_mailserver_cert() {

SCRIPT_PATH="/root/NeXt-Server-Buster"

source ${SCRIPT_PATH}/configs/versions.cfg
source ${SCRIPT_PATH}/configs/userconfig.cfg	

systemctl -q stop nginx.service

rm -R /root/.acme.sh/$mail.${MYDOMAIN}
rm /etc/nginx/ssl/mail.${MYDOMAIN}.cer
rm /etc/nginx/ssl/mail.${MYDOMAIN}.key

cd ${SCRIPT_PATH}/sources/acme.sh/
bash acme.sh --issue --debug 2 --standalone -d mail.${MYDOMAIN} -d imap.${MYDOMAIN} -d smtp.${MYDOMAIN} --keylength 4096 --staging >>"${main_log}" 2>>"${err_log}"

ln -s /root/.acme.sh/mail.${MYDOMAIN}/fullchain.cer /etc/nginx/ssl/mail.${MYDOMAIN}.cer
ln -s /root/.acme.sh/mail.${MYDOMAIN}/mail.${MYDOMAIN}.key /etc/nginx/ssl/mail.${MYDOMAIN}.key

systemctl -q start nginx.service
systemctl restart dovecot
systemctl restart postfix
}