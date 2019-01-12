#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_system() {


	if_exit "[ $USER != 'root' ]" "Please run the script as root"

	if_exit "[ $(lsb_release -is) != 'Debian' ] && [ $(lsb_release -cs) != 'buster' ]" "The script only works on Debian 10.x"

	LOCAL_KERNEL_VERSION=$(uname -a | awk '/Linux/ {print $(NF-7)}')
	if_exit "[ $LOCAL_KERNEL_VERSION != ${KERNEL_VERSION} ]" "Please upgrade your Linux Version ($LOCAL_KERNEL_VERSION) with apt-get update && apt-get dist-upgrade to match the script required Version ${KERNEL_VERSION} + reboot your server!"

	if_exit "[ $(grep MemTotal /proc/meminfo | awk '{print $2}') -lt 1000000 ]" "This script needs at least ~1000MB of memory"

	FREE=`df -k --output=avail "$PWD" | tail -n1`
	if_exit "[ $FREE -lt 9437184 ]" "This script needs at least 9 GB free disk space"

	if_exit "[ $(dpkg-query -l | grep dmidecode | wc -l) -ne 1 ]" "This script does not support the virtualization technology!"

	if [ "$(dmidecode -s system-product-name)" == 'Bochs' ] || [ "$(dmidecode -s system-product-name)" == 'KVM' ] || [ "$(dmidecode -s system-product-name)" == 'All Series' ] || [ "$(dmidecode -s system-product-name)" == 'OpenStack Nova' ] || [ "$(dmidecode -s system-product-name)" == 'Standard' ]; then
		echo > /dev/null
	else
		if [ $(dpkg-query -l | grep facter | wc -l) -ne 1 ]; then
			install_packages "facter libruby"
		fi

		if	[ "$(facter virtual)" == 'physical' ] || [ "$(facter virtual)" == 'kvm' ]; then
 		echo > /dev/null
		else
	        echo "This script does not support the virtualization technology ($(dmidecode -s system-product-name))"
			exit 1
       fi
	fi
}
