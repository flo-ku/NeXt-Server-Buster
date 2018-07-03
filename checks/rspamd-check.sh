#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_rspamd() {

source ${SCRIPT_PATH}/configs/userconfig.cfg

greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
ok="$(greenb [OKAY] -)"
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
error="$(redb [ERROR] -)"

if [ -e /etc/apt/sources.list.d/rspamd.list ]; then
  echo "${ok} rspamd.list does exist"
else
  echo "${error} rspamd.list does NOT exist"
fi

if [ -e /etc/rspamd/local.d/options.inc ]; then
  echo "${ok} options.inc does exist"
else
  echo "${error} options.inc does NOT exist"
fi

if [ -e /etc/rspamd/local.d/worker-normal.inc ]; then
  echo "${ok} worker-normal.inc does exist"
else
  echo "${error} worker-normal.inc does NOT exist"
fi

if [ -e /etc/rspamd/local.d/classifier-bayes.conf ]; then
  echo "${ok} classifier-bayes.conf does exist"
else
  echo "${error} classifier-bayes.conf does NOT exist"
fi

if [ -e /etc/rspamd/local.d/worker-controller.inc ]; then
  echo "${ok} worker-controller.inc does exist"
else
  echo "${error} worker-controller.inc does NOT exist"
fi

if [ -e /etc/rspamd/local.d/worker-proxy.inc ]; then
  echo "${ok} worker-proxy.inc does exist"
else
  echo "${error} worker-proxy.inc does NOT exist"
fi

if [ -e /etc/rspamd/local.d/logging.inc ]; then
  echo "${ok} logging.inc does exist"
else
  echo "${error} logging.inc does NOT exist"
fi

if [ -e /etc/rspamd/local.d/milter_headers.conf ]; then
  echo "${ok} milter_headers.conf does exist"
else
  echo "${error} milter_headers.conf does NOT exist"
fi

if [ -e /var/lib/rspamd/dkim/${CURRENT_YEAR}.key ]; then
  echo "${ok} ${CURRENT_YEAR}.key does exist"
else
  echo "${error} ${CURRENT_YEAR}.key does NOT exist"
fi

if [ -e /var/lib/rspamd/dkim/${CURRENT_YEAR}.txt ]; then
  echo "${ok} ${CURRENT_YEAR}.txt does exist"
else
  echo "${error} ${CURRENT_YEAR}.txt does NOT exist"
fi

if [ -e ${SCRIPT_PATH}/DKIM_KEY_ADD_TO_DNS.txt ]; then
  echo "${ok} DKIM_KEY_ADD_TO_DNS.txt does exist"
else
  echo "${error} DKIM_KEY_ADD_TO_DNS.txt does NOT exist"
fi

if [ -e /etc/rspamd/local.d/dkim_signing.conf ]; then
  echo "${ok} dkim_signing.conf does exist"
else
  echo "${error} dkim_signing.conf does NOT exist"
fi

if [ -e /etc/rspamd/local.d/redis.conf ]; then
  echo "${ok} redis.conf does exist"
else
  echo "${error} redis.conf does NOT exist"
fi

if [ -e /etc/nginx/_rspamd.conf ]; then
  echo "${ok} _rspamd.conf does exist"
else
  echo "${error} _rspamd.conf does NOT exist"
fi
}
