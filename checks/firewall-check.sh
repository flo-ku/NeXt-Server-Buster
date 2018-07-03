#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_firewall() {

#### not finished yet ####  

source ${SCRIPT_PATH}/configs/userconfig.cfg

greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
ok="$(greenb [OKAY] -)"
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
error="$(redb [ERROR] -)"

if [ -e /etc/arno-iptables-firewall/firewall.conf ]; then
  echo "${ok} firewall.conf does exist"
else
  echo "${error} firewall.conf does NOT exist"
fi

if [ -e /etc/cron.daily/blocked-hosts ]; then
  echo "${ok} blocked-hosts does exist"
else
  echo "${error} blocked-hosts does NOT exist"
fi
}
