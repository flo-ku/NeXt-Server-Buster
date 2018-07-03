#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_openssh() {

if [ -e /etc/ssh/sshd_config ]; then
  echo "${ok} sshd_config does exist"
else
  echo "${error} sshd_config does NOT exist"
fi

if [ -e /etc/issue ]; then
  echo "${ok} issue file does exist"
else
  echo "${error} issue file does NOT exist"
fi

if [ -e /etc/issue.net ]; then
  echo "${ok} issue.net file does exist"
else
  echo "${error} issue.net file does NOT exist"
fi

if [ -e ~/.ssh/authorized_keys2 ]; then
  echo "${ok} authorized_keys2 does exist"
else
  echo "${error} authorized_keys2 does NOT exist"
fi

if [ -e ${SCRIPT_PATH}/ssh_privatekey.txt ]; then
  echo "${ok} ssh_privatekey.txt does exist"
else
  echo "${error} ssh_privatekey.txt does NOT exist"
fi
}
