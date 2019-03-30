#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_lets_encrypt() {

trap error_exit ERR

mkdir -p /etc/nginx/ssl/

install_packages "certbot"
}

create_nginx_cert() {

#add case for ipv6!	
cp /etc/nginx/sites-available/${MYDOMAIN}.conf /etc/nginx/sites-available/${MYDOMAIN}.vhost
cp ${SCRIPT_PATH}/configs/nginx/little_vhost /etc/nginx/sites-available/${MYDOMAIN}.conf	

service nginx start

cd /etc/nginx/ssl/

openssl ecparam -genkey -name secp384r1 -out ${MYDOMAIN}.pem
openssl req -new  -key ${MYDOMAIN}.pem -out ${MYDOMAIN}.csr -subj "/CN=${MYDOMAIN}" -sha256

certbot certonly --webroot -w /var/www/${MYDOMAIN}/public/ -d ${MYDOMAIN} -m ${NXT_SYSTEM_EMAIL} -n --agree-tos --csr ${MYDOMAIN}.csr --test-cert 

cp /etc/nginx/ssl/0001_chain.pem /etc/nginx/ssl/fullchain.pem
cp /etc/nginx/ssl/${MYDOMAIN}.pem /etc/nginx/ssl/privkey.pem
cp /etc/nginx/ssl/0000_chain.pem  /etc/nginx/ssl/chain.pem

cp /etc/nginx/sites-available/${MYDOMAIN}.conf /etc/nginx/sites-available/little_vhost
cp /etc/nginx/sites-available/${MYDOMAIN}.vhost /etc/nginx/sites-available/${MYDOMAIN}.conf

exit

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
