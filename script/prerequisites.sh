#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

prerequisites() {

	#Get out nfs
	apt-get -y --purge remove nfs-kernel-server nfs-common portmap rpcbind >>"${main_log}" 2>>"${err_log}"

	if [ $(dpkg-query -l | grep build-essential | wc -l) -ne 1 ]; then
		install_packages "build-essential"
	fi

	if [ $(dpkg-query -l | grep dbus | wc -l) -ne 1 ]; then
		install_packages "dbus"
	fi

	if [ $(dpkg-query -l | grep libcrack2 | wc -l) -ne 1 ]; then
		install_packages "libcrack2"
	fi

#	if [ $(dpkg-query -l | grep libirs160 | wc -l) -ne 1 ]; then
#		install_packages "libirs160"
#	fi

#	if [ $(dpkg-query -l | grep bind9-host | wc -l) -ne 1 ]; then
#		install_packages "bind9-host"
#	fi

#	if [ $(dpkg-query -l | grep libbind9-160 | wc -l) -ne 1 ]; then
#		install_packages "libbind9-160"
#	fi

#	if [ $(dpkg-query -l | grep libdns1102 | wc -l) -ne 1 ]; then
#		install_packages "libdns1102"
#	fi
#
#	if [ $(dpkg-query -l | grep libisc169 | wc -l) -ne 1 ]; then
#		install_packages "libisc169"
#	fi
#
#	if [ $(dpkg-query -l | grep liblwres160 | wc -l) -ne 1 ]; then
#		install_packages "liblwres160"
#	fi
#
#	if [ $(dpkg-query -l | grep libisccc160 | wc -l) -ne 1 ]; then
#		install_packages "libisccc160"
#	fi
#
#	if [ $(dpkg-query -l | grep libisccfg160 | wc -l) -ne 1 ]; then
#		install_packages "libisccfg160"
#	fi

	if [ $(dpkg-query -l | grep dnsutils | wc -l) -ne 1 ]; then
		install_packages "dnsutils"
	fi

	if [ $(dpkg-query -l | grep netcat | wc -l) -ne 1 ]; then
		install_packages "netcat"
	fi

	if [ $(dpkg-query -l | grep automake | wc -l) -ne 1 ]; then
		install_packages "automake"
	fi

	if [ $(dpkg-query -l | grep autoconf | wc -l) -ne 1 ]; then
		install_packages "autoconf"
	fi

	if [ $(dpkg-query -l | grep gawk | wc -l) -ne 1 ]; then
		install_packages "gawk"
	fi

	if [ $(dpkg-query -l | grep lsb-release | wc -l) -ne 1 ]; then
		install_packages "lsb-release"
	fi
}
