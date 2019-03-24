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
./acme.sh --install --accountemail ${NXT_SYSTEM_EMAIL} >>"${main_log}" 2>>"${err_log}"

. ~/.bashrc >>"${main_log}" 2>>"${err_log}"
. ~/.profile >>"${main_log}" 2>>"${err_log}"
}

create_nginx_cert() {

cd ${SCRIPT_PATH}/sources/acme.sh/
echo "Vor ausstellen"
set -x
bash acme.sh --issue -w /var/www/${MYDOMAIN}/public/ --d ${MYDOMAIN} -d www.${MYDOMAIN} --keylength ec-384 --staging >>"${main_log}" 2>>"${err_log}"
echo "Nach ausstellen"

echo "Vor ausstellen 2"
bash acme.sh --issue -w /var/www/${MYDOMAIN}/public/.well-known/acme-challenge/ --d ${MYDOMAIN} -d www.${MYDOMAIN} --keylength ec-384 --staging >>"${main_log}" 2>>"${err_log}"
echo "Nach ausstellen 2"

exit

ln -s /root/.acme.sh/${MYDOMAIN}_ecc/fullchain.cer /etc/nginx/ssl/${MYDOMAIN}-ecc.cer >>"${main_log}" 2>>"${err_log}"
ln -s /root/.acme.sh/${MYDOMAIN}_ecc/${MYDOMAIN}.key /etc/nginx/ssl/${MYDOMAIN}-ecc.key >>"${main_log}" 2>>"${err_log}"

HPKP1=$(openssl x509 -pubkey < /etc/nginx/ssl/${MYDOMAIN}-ecc.cer | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64) >>"${main_log}" 2>>"${err_log}"
HPKP2=$(openssl rand -base64 32) >>"${main_log}" 2>>"${err_log}"

#SED doesn't work when the HPKP contains "/", so we escape it
HPKP1=$(echo "$HPKP1" | sed 's/\//\\\//g')
HPKP2=$(echo "$HPKP2" | sed 's/\//\\\//g')

sed -i "s/HPKP1/${HPKP1}/g" /etc/nginx/_general.conf
sed -i "s/HPKP2/${HPKP2}/g" /etc/nginx/_general.conf
}

update_lets_encrypt() {
  cd ${SCRIPT_PATH}/.acme.sh/
  acme.sh --upgrade
}
