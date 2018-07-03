#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_lets_encrypt() {

if [ -e /root/.acme.sh/${MYDOMAIN}_ecc/fullchain.cer ]; then
  echo "${ok} fullchain.cer does exist"
else
  echo "${error} fullchain.cer does NOT exist"
fi

if [ -e /etc/nginx/ssl/${MYDOMAIN}-ecc.cer ]; then
  echo "${ok} ${MYDOMAIN}-ecc.cer does exist"
else
  echo "${error} ${MYDOMAIN}-ecc.cer does NOT exist"
fi

if [ -e /root/.acme.sh/${MYDOMAIN}_ecc/${MYDOMAIN}.key ]; then
  echo "${ok} ${MYDOMAIN}.key does exist"
else
  echo "${error} ${MYDOMAIN}.key does NOT exist"
fi

if [ -e /etc/nginx/ssl/${MYDOMAIN}-ecc.key ]; then
  echo "${ok} ${MYDOMAIN}-ecc.key does exist"
else
  echo "${error} ${MYDOMAIN}-ecc.key does NOT exist"
fi
}
