#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_mailserver() {

if [ -e /root/.acme.sh/mail.${MYDOMAIN}/fullchain.cer ]; then
  echo "${ok} fullchain.cer mailserver does exist"
else
  echo "${error} fullchain.cer mailserver does NOT exist"
fi

if [ -e /etc/nginx/ssl/mail.${MYDOMAIN}.cer ]; then
  echo "${ok} mail.${MYDOMAIN}.cer does exist"
else
  echo "${error} mail.${MYDOMAIN}.cer does NOT exist"
fi

if [ -e /root/.acme.sh/mail.${MYDOMAIN}/mail.${MYDOMAIN}.key ]; then
  echo "${ok} mail.${MYDOMAIN}.key does exist"
else
  echo "${error} mail.${MYDOMAIN}.key does NOT exist"
fi

if [ -e /etc/nginx/ssl/mail.${MYDOMAIN}.key ]; then
  echo "${ok} /etc/nginx/ssl/mail.${MYDOMAIN}.key does exist"
else
  echo "${error} /etc/nginx/ssl/mail.${MYDOMAIN}.key does NOT exist"
fi
}
