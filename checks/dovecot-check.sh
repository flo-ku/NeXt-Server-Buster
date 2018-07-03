#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_dovecot() {

source ${SCRIPT_PATH}/configs/userconfig.cfg

greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
ok="$(greenb [OKAY] -)"
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
error="$(redb [ERROR] -)"

if [ -e /etc/dovecot/dovecot.conf ]; then
  echo "${ok} dovecot.conf does exist"
else
  echo "${error} dovecot.conf does NOT exist"
fi

if [ -e /etc/dovecot/dovecot-sql.conf ]; then
  echo "${ok} dovecot-sql.conf does exist"
else
  echo "${error} dovecot-sql.conf does NOT exist"
fi

if [ -e /var/vmail/sieve/global/spam-global.sieve ]; then
  echo "${ok} spam-global.sieve does exist"
else
  echo "${error} spam-global.sieve does NOT exist"
fi

if [ -e /var/vmail/sieve/global/learn-spam.sieve ]; then
  echo "${ok} learn-spam.sieve does exist"
else
  echo "${error} learn-spam.sieve does NOT exist"
fi

if [ -e /var/vmail/sieve/global/learn-ham.sieve ]; then
  echo "${ok} learn-ham.sieve does exist"
else
  echo "${error} learn-ham.sieve does NOT exist"
fi
}
