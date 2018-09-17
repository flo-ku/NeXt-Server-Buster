#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

menu_options_mailserver() {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=7
BACKTITLE="NeXt Server"
TITLE="NeXt Server"
MENU="Choose one of the following options:"

	OPTIONS=(1 "List all known accounts and aliases."
			 2 "Add an account."
			 3 "Change settings of an account."
       4 "Change password of an account."
       5 "Delete an account.")
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
				./managevmail.py list
        read -p "Continue (y/n)?" ANSW
        if [ "$ANSW" = "n" ]; then
        echo "Exit"
        exit 1
        fi
        source ${SCRIPT_PATH}/menus/mailserver_menu.sh; menu_options_mailserver
				;;
			2)
        ./managevmail.py add
        read -p "Continue (y/n)?" ANSW
        if [ "$ANSW" = "n" ]; then
        echo "Exit"
        exit 1
        fi
        source ${SCRIPT_PATH}/menus/mailserver_menu.sh; menu_options_mailserver
				;;
			3)
        ./managevmail.py change
        read -p "Continue (y/n)?" ANSW
        if [ "$ANSW" = "n" ]; then
        echo "Exit"
        exit 1
        fi
        source ${SCRIPT_PATH}/menus/mailserver_menu.sh; menu_options_mailserver
        ;;
      4)
        ./managevmail.py pw
        read -p "Continue (y/n)?" ANSW
        if [ "$ANSW" = "n" ]; then
        echo "Exit"
        exit 1
        fi
        source ${SCRIPT_PATH}/menus/mailserver_menu.sh; menu_options_mailserver
        ;;
      5)
        ./managevmail.py delete
        read -p "Continue (y/n)?" ANSW
        if [ "$ANSW" = "n" ]; then
        echo "Exit"
        exit 1
        fi
        source ${SCRIPT_PATH}/menus/mailserver_menu.sh; menu_options_mailserver
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
