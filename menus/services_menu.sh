#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

menu_options_services() {

SCRIPT_PATH="/root/NeXt-Server-Buster"

source ${SCRIPT_PATH}/configs/versions.cfg
source ${SCRIPT_PATH}/script/functions.sh
source ${SCRIPT_PATH}/script/logs.sh; set_logs

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=7
BACKTITLE="NeXt Server"
TITLE="NeXt Server"
MENU="Choose one of the following options:"

		OPTIONS=(1 "Mailserver Options"
             2 "Openssh Options"
						 3 "Fail2ban Options"
             4 "Lets Encrypt Options"
             5 "Firewall Options"
             6 "Back"
						 7 "Exit")

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
	source ${SCRIPT_PATH}/menus/mailserver_menu.sh; menu_options_mailserver
	;;
2)
	source ${SCRIPT_PATH}/menus/openssh_menu.sh; menu_options_openssh
	;;
3)
	source ${SCRIPT_PATH}/menus/fail2ban_menu.sh; menu_options_fail2ban
	;;
4)
	source ${SCRIPT_PATH}/menus/lets_encrypt_menu.sh; menu_options_lets_encrypt
	;;
5)
	source ${SCRIPT_PATH}/menus/firewall_menu.sh; menu_options_firewall
	;;
6)
  bash ${SCRIPT_PATH}/nxt.sh;
  ;;
7)
	echo "Exit"
	exit 1
	;;
esac

}
