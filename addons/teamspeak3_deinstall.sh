#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

deinstall_teamspeak3() {
set -x

deluser ts3user
rm -rf /usr/local/ts3user
rm ${SCRIPT_PATH}/ts3serverdata.txt
rm /etc/init.d/ts3server

#### close ports in firewall!
systemctl force-reload arno-iptables-firewall.service >>"${main_log}" 2>>"${err_log}"
}
