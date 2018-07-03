#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_mailman() {

if [ -e /etc/nginx/_mailman.conf ]; then
  echo "${ok} _mailman.conf does exist"
else
  echo "${error} _mailman.conf does NOT exist"
fi
}
