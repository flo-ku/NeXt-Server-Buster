#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_mailman() {

source ${SCRIPT_PATH}/configs/userconfig.cfg

greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
ok="$(greenb [OKAY] -)"
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
error="$(redb [ERROR] -)"

if [ -e /etc/nginx/_mailman.conf ]; then
  echo "${ok} _mailman.conf does exist"
else
  echo "${error} _mailman.conf does NOT exist"
fi
}
