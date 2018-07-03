#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_fail2ban() {

if [ -e /etc/fail2ban/fail2ban.local ]; then
  echo "${ok} fail2ban.local does exist"
else
  echo "${error} fail2ban.local does NOT exist"
fi

if [ -e /etc/fail2ban/jail.local ]; then
  echo "${ok} jail.local does exist"
else
  echo "${error} jail.local does NOT exist"
fi

if [ -e /etc/fail2ban/filter.d/webserver-w00tw00t.conf ]; then
  echo "${ok} webserver-w00tw00t.conf does exist"
else
  echo "${error} webserver-w00tw00t.conf does NOT exist"
fi

if [ -e /etc/init.d/fail2ban ]; then
  echo "${ok} fail2ban initd does exist"
else
  echo "${error} fail2ban initd does NOT exist"
fi
}
