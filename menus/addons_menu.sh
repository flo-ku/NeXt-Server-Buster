#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

menu_options_addons() {

SCRIPT_PATH="/root/NeXt-Server-Buster"

source ${SCRIPT_PATH}/configs/versions.cfg
source ${SCRIPT_PATH}/script/functions.sh
source ${SCRIPT_PATH}/script/logs.sh; set_logs
source ${SCRIPT_PATH}/script/prerequisites.sh; prerequisites
source ${SCRIPT_PATH}/configs/userconfig.cfg

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="NeXt Server"
TITLE="NeXt Server"
MENU="Choose one of the following options:"

		OPTIONS=(1 "Install TS3 Server"
		 				 2 "Deinstall TS3 Server"
						 3 "Install Minecraft"
						 4 "Install Composer"
						 5 "Install Nextcloud"
						 6 "Deinstall Nextcloud"
						 7 "Install phpmyadmin"
						 8 "Install Munin"
             9 "Install Wordpress"
						 10 "Deinstall Wordpress"
						 11 "Back"
						 12 "Exit")

						 CHOICE=$(dialog --clear \
										 --nocancel \
										 --no-cancel \
										 --backtitle "$BACKTITLE" \
										 --title "$TITLE" \
										 --menu "$MENU" \
										 $HEIGHT $WIDTH $CHOICE_HEIGHT \
										 "${OPTIONS[@]}" \
										 2>&1 >/dev/tty)

						 clear
						 case $CHOICE in

1)
	if [[ ${NXT_IS_INSTALLED} == '1' ]] || [[ ${NXT_IS_INSTALLED_MAILSERVER} == '1' ]]; then
		dialog_info "Installing Teamspeak 3"
		source ${SCRIPT_PATH}/addons/teamspeak3.sh; install_teamspeak3
		dialog_msg "Finished installing Teamspeak 3! Credentials: ${SCRIPT_PATH}/login_information.txt"
	else
		echo "You have to install the NeXt Server to run this Addon!"
	fi
	;;
2)
	dialog_info "Deinstalling Teamspeak 3"
		source ${SCRIPT_PATH}/addons/teamspeak3_deinstall.sh; deinstall_teamspeak3
	dialog_msg "Finished Deinstalling Teamspeak 3.\n
	Closed Ports TCP: 2008, 10011, 30033, 41144\n
	UDP: 2010, 9987\n
	IF you need them, pelase reopen them manually!"
	;;
3)
	if [[ ${NXT_IS_INSTALLED} == '1' ]] || [[ ${NXT_IS_INSTALLED_MAILSERVER} == '1' ]]; then
		dialog_info "Installing Minecraft"
		source ${SCRIPT_PATH}/addons/minecraft.sh; install_minecraft
		dialog_msg "Finished installing Minecraft! Credentials: ${SCRIPT_PATH}/login_information.txt"
	else
		echo "You have to install the NeXt Server to run this Addon!"
	fi
	;;
4)
	if [[ ${NXT_IS_INSTALLED} == '1' ]] || [[ ${NXT_IS_INSTALLED_MAILSERVER} == '1' ]]; then
	dialog_info "Installing Composer"
	source ${SCRIPT_PATH}/addons/composer.sh; install_composer
	dialog_msg "Finished installing Composer"
else
	echo "You have to install the NeXt Server with the Webserver component to run this Addon!"
fi
;;
5)
	if [[ ${USE_PHP7_2} == '1'  ]] || [[ ${USE_PHP7_3} == '1'  ]]; then
		if [[ ${NXT_IS_INSTALLED} == '1' ]] || [[ ${NXT_IS_INSTALLED_MAILSERVER} == '1' ]]; then
			dialog_info "Installing Nextcloud"
			#source ${SCRIPT_PATH}/menus/nextcloud_menu.sh; menu_options_nextcloud
			source ${SCRIPT_PATH}/addons/nextcloud.sh; install_nextcloud
			dialog_msg "Finished installing Nextcloud"
		else
			echo "You have to install the NeXt Server with the Webserver component to run this Addon!"
		fi
	else
		echo "Nextcloud 13 is only running on PHP 7.2 and 7.3!"
	fi
	;;
6)
	dialog_info "Deinstalling Nextcloud"
		source ${SCRIPT_PATH}/addons/nextcloud_deinstall.sh; deinstall_nextcloud
	dialog_msg "Finished Deinstalling Nextcloud"
	;;
7)
	if [[ ${NXT_IS_INSTALLED} == '1' ]] || [[ ${NXT_IS_INSTALLED_MAILSERVER} == '1' ]]; then
		dialog_info "Installing PHPmyadmin"
		source ${SCRIPT_PATH}/addons/composer.sh; install_composer
		source ${SCRIPT_PATH}/addons/phpmyadmin.sh; install_phpmyadmin
		dialog_msg "Finished installing PHPmyadmin"
	else
		echo "You have to install the NeXt Server with the Webserver component to run this Addon!"
	fi
	;;
8)
	if [[ ${NXT_IS_INSTALLED} == '1' ]] || [[ ${NXT_IS_INSTALLED_MAILSERVER} == '1' ]]; then
		dialog_info "Installing Munin"
		source ${SCRIPT_PATH}/addons/munin.sh; install_munin
		dialog_msg "Finished installing Munin"
	else
		echo "You have to install the NeXt Server with the Webserver component to run this Addon!"
	fi
	;;
9)
	if [[ ${NXT_IS_INSTALLED} == '1' ]] || [[ ${NXT_IS_INSTALLED_MAILSERVER} == '1' ]]; then
		source ${SCRIPT_PATH}/menus/wordpress_menu.sh; menu_options_wordpress
		source ${SCRIPT_PATH}/addons/wordpress.sh; install_wordpress
		dialog_msg "Finished installing Wordpress"
	else
		echo "You have to install the NeXt Server with the Webserver component to run this Addon!"
	fi
	;;
10)
	dialog_info "Deinstalling Wordpress"
		source ${SCRIPT_PATH}/addons/wordpress_deinstall.sh; deinstall_wordpress
	dialog_msg "Finished Deinstalling Wordpress"
	;;
11)
  bash ${SCRIPT_PATH}/nxt.sh;
  ;;
12)
	echo "Exit"
	exit 1
	;;
esac
}
