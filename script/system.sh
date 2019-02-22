#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_system() {

trap error_exit ERR

source ${SCRIPT_PATH}/configs/userconfig.cfg

rm /etc/network/interfaces
if [[ ${IPV6_ONLY} = "1" ]]; then
  cp -f ${SCRIPT_PATH}/configs/IPv6.interface /etc/network/interfaces
  sed -i "s/IPV6ADDR/${IP6ADR}/" /etc/network/interfaces
  sed -i "s/IPV6GATE/${IPV6GAT}/" /etc/network/interfaces
  sed -i "s/IPV6NET/${IPV6NET}/" /etc/network/interfaces
fi

if [[ ${IP_DUAL} = "1" ]]; then
  cp -f ${SCRIPT_PATH}/configs/IPv4-IPv6.interface /etc/network/interfaces
  sed -i "s/IPV4ADDR/${IPADR}/" /etc/network/interfaces
  sed -i "s/IPV4GATE/${IPV4GAT}/" /etc/network/interfaces
  sed -i "s/IPV6ADDR/${IP6ADR}/" /etc/network/interfaces
  sed -i "s/IPV6GATE/${IPV6GAT}/" /etc/network/interfaces
  sed -i "s/IPV6NET/${IPV6NET}/" /etc/network/interfaces
fi

hostnamectl set-hostname --static mail

rm /etc/hosts
cat > /etc/hosts <<END
127.0.0.1   localhost
127.0.1.1   mail.domain.tld  mail

::1         localhost ip6-localhost ip6-loopback
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters
END
sed -i "s/domain.tld/${MYDOMAIN}/g" /etc/hosts

echo $(hostname -f) > /etc/mailname

TIMEZONE_DETECTED=$(wget http://ip-api.com/line/${IPADR}?fields=timezone -q -O -)
timedatectl set-timezone ${TIMEZONE_DETECTED}

TIMEZONE_DETECTED=$(echo "$TIMEZONE_DETECTED" | sed 's/\//\\\//g')
sed -i "s/EMPTY_TIMEZONE/${TIMEZONE_DETECTED}/g" ${SCRIPT_PATH}/configs/userconfig.cfg

rm /etc/apt/sources.list
cat > /etc/apt/sources.list <<END
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                                      #
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ testing main contrib non-free
deb-src http://deb.debian.org/debian/ testing main contrib non-free

deb http://deb.debian.org/debian/ testing-updates main contrib non-free
deb-src http://deb.debian.org/debian/ testing-updates main contrib non-free

deb http://deb.debian.org/debian-security testing/updates main
deb-src http://deb.debian.org/debian-security testing/updates main
END

apt-get update -y >/dev/null 2>&1
apt-get -y upgrade >/dev/null 2>&1

install_packages "sudo rkhunter debsecan debsums passwdqc unattended-upgrades needrestart apt-listchanges"
cp -f ${SCRIPT_PATH}/configs/needrestart.conf /etc/needrestart/needrestart.conf
cp -f ${SCRIPT_PATH}/configs/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
cp -f ${SCRIPT_PATH}/configs/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s/email_address=root/email_address=${NXT_SYSTEM_EMAIL}/g" /etc/apt/listchanges.conf
sed -i "s/changeme/${NXT_SYSTEM_EMAIL}/g" /etc/apt/apt.conf.d/50unattended-upgrades

cp -f ${SCRIPT_PATH}/cronjobs/webserver_backup /etc/cron.daily/
chmod +x /etc/cron.daily/webserver_backup

cp -f ${SCRIPT_PATH}/cronjobs/free_disk_space /etc/cron.daily/
sed -i "s/changeme/${NXT_SYSTEM_EMAIL}/g" /etc/cron.daily/free_disk_space
chmod +x /etc/cron.daily/free_disk_space
}
