#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_rspamd() {

install_packages "lsb-release wget"

wget -q -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - >>"${main_log}" 2>>"${err_log}"
echo "deb http://rspamd.com/apt-stable/ sid main" > /etc/apt/sources.list.d/rspamd.list
echo "deb-src http://rspamd.com/apt-stable/ sid main" >> /etc/apt/sources.list.d/rspamd.list
#echo "deb http://rspamd.com/apt-stable/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/rspamd.list
#echo "deb-src http://rspamd.com/apt-stable/ $(lsb_release -c -s) main" >> /etc/apt/sources.list.d/rspamd.list

apt-get update -y >/dev/null 2>&1
install_packages "rspamd"
systemctl stop rspamd

cp ${SCRIPT_PATH}/configs/rspamd/options.inc /etc/rspamd/local.d/options.inc
cp ${SCRIPT_PATH}/configs/rspamd/worker-normal.inc /etc/rspamd/local.d/worker-normal.inc
cp ${SCRIPT_PATH}/configs/rspamd/classifier-bayes.conf /etc/rspamd/local.d/classifier-bayes.conf

RSPAMADM_PASSWORT=$(password)

if [ -z "${RSPAMADM_PASSWORT}" ]; then
    echo "RSPAMADM_PASSWORT is unset or set to the empty string, creating new one!"
    RSPAMADM_PASSWORT=$(password)
fi

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "RSPAMADM URL: https://${MYDOMAIN}/rspamd/" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "RSPAMADM_PASSWORT: $RSPAMADM_PASSWORT" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt

RSPAMADM_PASSWORT_HASH=$(rspamadm pw -p ${RSPAMADM_PASSWORT})

cat > /etc/rspamd/local.d/worker-controller.inc <<END
password = "${RSPAMADM_PASSWORT_HASH}";
END

cp ${SCRIPT_PATH}/configs/rspamd/worker-proxy.inc /etc/rspamd/local.d/worker-proxy.inc
cp ${SCRIPT_PATH}/configs/rspamd/logging.inc /etc/rspamd/local.d/logging.inc
cp ${SCRIPT_PATH}/configs/rspamd/milter_headers.conf /etc/rspamd/local.d/milter_headers.conf

CURRENT_YEAR=$(date +'%Y')

mkdir /var/lib/rspamd/dkim/
rspamadm dkim_keygen -b 2048 -s ${CURRENT_YEAR} -k /var/lib/rspamd/dkim/${CURRENT_YEAR}.key >>"${main_log}" 2>>"${err_log}"
cp /var/lib/rspamd/dkim/${CURRENT_YEAR}.key /var/lib/rspamd/dkim/${CURRENT_YEAR}.txt
chown -R _rspamd:_rspamd /var/lib/rspamd/dkim
chmod 440 /var/lib/rspamd/dkim/*
cp /var/lib/rspamd/dkim/${CURRENT_YEAR}.txt ${SCRIPT_PATH}/DKIM_KEY_ADD_TO_DNS.txt

cp ${SCRIPT_PATH}/configs/rspamd/dkim_signing.conf /etc/rspamd/local.d/dkim_signing.conf
sed -i "s/placeholder/${CURRENT_YEAR}/g" /etc/rspamd/local.d/dkim_signing.conf

cp -R /etc/rspamd/local.d/dkim_signing.conf /etc/rspamd/local.d/arc.conf

#install_packages "redis-server"
#temporary fix until redis-server is working in buster repos
wget http://security.debian.org/debian-security/pool/updates/main/r/redis/redis-tools_3.2.6-3+deb9u1_amd64.deb
dpkg -i redis-tools_3.2.6-3+deb9u1_amd64.deb

wget http://security.debian.org/debian-security/pool/updates/main/r/redis/redis-server_3.2.6-3+deb9u1_amd64.deb
dpkg -i redis-server_3.2.6-3+deb9u1_amd64.deb

cp ${SCRIPT_PATH}/configs/rspamd/redis.conf /etc/rspamd/local.d/redis.conf

REDIS_PASSWORT=$(password)
sed -i "s/# rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52/rename-command CONFIG ${REDIS_PASSWORT}/g" /etc/redis/redis.conf

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "Redis Password: ${REDIS_PASSWORT}" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt

cp ${SCRIPT_PATH}/configs/mailserver/_rspamd.conf /etc/nginx/_rspamd.conf
sed -i "s/#include _rspamd.conf;/include _rspamd.conf;/g" /etc/nginx/sites-available/${MYDOMAIN}.conf

systemctl restart redis-server
systemctl restart nginx
systemctl start rspamd
systemctl start dovecot
systemctl start postfix
}
