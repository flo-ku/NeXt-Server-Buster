#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_system() {

source ${SCRIPT_PATH}/configs/userconfig.cfg

greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
ok="$(greenb [OKAY] -)"
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
error="$(redb [ERROR] -)"

if [ -e /etc/hosts ]; then
  echo "${ok} hosts does exist"
else
  echo "${error} hosts does NOT exist"
fi

if [ -e /etc/mailname ]; then
  echo "${ok} mailname does exist"
else
  echo "${error} mailname does NOT exist"
fi

if [ -e /etc/apt/sources.list ]; then
  echo "${ok} sources.list does exist"
else
  echo "${error} sources.list does NOT exist"
fi

if [ -e /etc/sysctl.conf ]; then
  echo "${ok} sysctl.conf does exist"
else
  echo "${error} sysctl.conf does NOT exist"
fi

if [ -e /etc/cron.daily/backupscript ]; then
  echo "${ok} backupscript does exist"
else
  echo "${error} backupscript does NOT exist"
fi

if [ -e ${SCRIPT_PATH}/login_information.txt ]; then
  echo "${ok} login_information.txt does exist"
else
  echo "${error} login_information.txt does NOT exist"
fi

if [ -e ${SCRIPT_PATH}/dns_settings.txt ]; then
  echo "${ok} dns_settings.txt does exist"
else
  echo "${error} dns_settings.txt does NOT exist"
fi
}
