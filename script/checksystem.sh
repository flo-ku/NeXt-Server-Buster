#!/bin/bash
# Compatible with Ubuntu 16.04 Xenial and Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_system() {

	if [ $USER != 'root' ]; then
        echo "Please run the script as root"
		exit 1
	fi

	if [ $(lsb_release -is) != 'Debian' ] && [ $(lsb_release -is) != 'Ubuntu' ]; then
		echo "The script only works on Ubuntu 16.04 Xenial and Debian 10.x"
		exit 1
	fi

	if [ $(lsb_release -cs) != 'xenial' ] && [ $(lsb_release -cs) != 'buster' ]; then
		echo "The script only works on Ubuntu 16.04 Xenial and Debian 10.x"
		exit 1
	fi

	if [ $(lsb_release -cs) == 'xenial' ] && [ $(lsb_release -is) == 'Ubuntu' ]; then
		DISTOS="UBUNTU"
	fi

	if [ $(lsb_release -cs) == 'buster' ] && [ $(lsb_release -is) == 'Debian' ]; then
		DISTOS="DEBIAN"
	fi

	LOCAL_KERNEL_VERSION=$(uname -a | awk '/Linux/ {print $(NF-7)}')
	if [ $LOCAL_KERNEL_VERSION != ${KERNEL_VERSION} ]; then
      echo "Please upgrade your Linux Version ($LOCAL_KERNEL_VERSION) with apt-get update && apt-get dist-upgrade to match the script required Version ${KERNEL_VERSION}"
			exit 1
	fi

	if [ $(grep MemTotal /proc/meminfo | awk '{print $2}') -lt 1000000 ]; then
		echo "This script needs at least ~1000MB of memory"
	fi

	FREE=`df -k --output=avail "$PWD" | tail -n1`
	if [[ $FREE -lt 9437184 ]]; then
		echo "This script needs at least 9 GB free disk space"
		exit 1
	fi

	if [ $(dpkg-query -l | grep dmidecode | wc -l) -ne 1 ]; then
    	echo "This script does not support the virtualization technology!"
		exit 1
	fi

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

	#cleanup
	apt-get -y remove facter libruby >/dev/null 2>&1
	apt -y autoremove >/dev/null 2>&1
}
