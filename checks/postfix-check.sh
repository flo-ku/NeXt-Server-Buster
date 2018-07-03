#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_postfix() {

source ${SCRIPT_PATH}/configs/userconfig.cfg

greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
ok="$(greenb [OKAY] -)"
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
error="$(redb [ERROR] -)"

if [ -e /etc/postfix/main.cf ]; then
  echo "${ok} main.cf does exist"
else
  echo "${error} main.cf does NOT exist"
fi

if [ -e /etc/postfix/master.cf ]; then
  echo "${ok} master.cf does exist"
else
  echo "${error} master.cf does NOT exist"
fi

if [ -e /etc/postfix/submission_header_cleanup ]; then
  echo "${ok} submission_header_cleanup does exist"
else
  echo "${error} submission_header_cleanup does NOT exist"
fi

if [ -e /etc/postfix/sql/accounts.cf ]; then
  echo "${ok} accounts.cf does exist"
else
  echo "${error} accounts.cf does NOT exist"
fi

if [ -e /etc/postfix/sql/aliases.cf ]; then
  echo "${ok} aliases.cf does exist"
else
  echo "${error} aliases.cf does NOT exist"
fi

if [ -e /etc/postfix/sql/domains.cf ]; then
  echo "${ok} domains.cf does exist"
else
  echo "${error} domains.cf does NOT exist"
fi

if [ -e /etc/postfix/sql/recipient-access.cf ]; then
  echo "${ok} recipient-access.cf does exist"
else
  echo "${error} recipient-access.cf does NOT exist"
fi

if [ -e /etc/postfix/sql/sender-login-maps.cf ]; then
  echo "${ok} sender-login-maps.cf does exist"
else
  echo "${error} sender-login-maps.cf does NOT exist"
fi

if [ -e /etc/postfix/sql/tls-policy.cf ]; then
  echo "${ok} tls-policy.cf does exist"
else
  echo "${error} tls-policy.cf does NOT exist"
fi

if [ -e /etc/postfix/without_ptr ]; then
  echo "${ok} without_ptr does exist"
else
  echo "${error} without_ptr does NOT exist"
fi

if [ -e /etc/postfix/postscreen_access ]; then
  echo "${ok} postscreen_access does exist"
else
  echo "${error} postscreen_access does NOT exist"
fi
}
