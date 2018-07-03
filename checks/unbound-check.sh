#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_unbound() {

source ${SCRIPT_PATH}/configs/userconfig.cfg

greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
ok="$(greenb [OKAY] -)"
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
error="$(redb [ERROR] -)"

if [ -e /etc/resolvconf/resolv.conf.d/head ]; then
  echo "${ok} head file does exist"
else
  echo "${error} head file does NOT exist"
fi

if [ -e /etc/unbound/unbound.conf ]; then
  echo "${ok} unbound.conf does exist"
else
  echo "${error} unbound.conf does NOT exist"
fi

if [ -e /var/lib/unbound/root.key ]; then
  echo "${ok} root.key does exist"
else
  echo "${error} root.key does NOT exist"
fi
}
