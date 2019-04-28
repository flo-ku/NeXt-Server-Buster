#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

menu_options_openssh() {

trap error_exit ERR

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=5
BACKTITLE="NeXt Server"
TITLE="NeXt Server"
MENU="Choose one of the following options:"

	OPTIONS=(1 "Add new Openssh User"
			 2 "Change Openssh Port"
			 3 "Create new Openssh Key"
			 4 "Back"
			 5 "Exit")

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
				NEW_OPENSSH_USER=$(dialog --clear \
				--backtitle "$BACKTITLE" \
				--inputbox "Please enter the new Openssh Username:" \
				$HEIGHT $WIDTH \
				3>&1 1>&2 2>&3 3>&- \
				)
				source ${SCRIPT_PATH}/script/openssh_options.sh; add_openssh_user
				dialog_msg "Finished adding Openssh User"
				source ${SCRIPT_PATH}/script/functions.sh; continue_or_exit
				source ${SCRIPT_PATH}/menus/openssh_menu.sh; menu_options_openssh
				;;
			2)
			while true
				do
					INPUT_NEW_SSH_PORT=$(dialog --clear \
							--backtitle "$BACKTITLE" \
							--inputbox "Enter your SSH Port (only max. 3 numbers!):" \
							$HEIGHT $WIDTH \
							3>&1 1>&2 2>&3 3>&- \
							)
					if [[ $INPUT_NEW_SSH_PORT =~ ^-?[0-9]+$ ]]; then
						if [ ${#INPUT_NEW_SSH_PORT} -ge 4 ]; then
								dialog_msg "Your Input has more than 3 numbers, please try again"
								dialog --clear
						else
								array=($(cat "${SCRIPT_PATH}/configs/blocked_ports.conf"))
								printf -v array_str -- ',,%q' "${array[@]}"
									while true
									do
										if [[ "${array_str},," =~ ,,${INPUT_NEW_SSH_PORT},, ]]; then
											dialog_msg "$INPUT_NEW_SSH_PORT is known. Choose an other Port!"
											dialog --clear
										else
											NEW_SSH_PORT="$INPUT_NEW_SSH_PORT"
											sed -i "s/^Port .*/Port $NEW_SSH_PORT/g" /etc/ssh/sshd_config
											break
										fi
									done
								echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
								echo "#Date of change $(date +"%d-%m-%Y_%H_%M_%S")" >> ${SCRIPT_PATH}/login_information.txt
								echo "#NEW_SSH_PORT: $NEW_SSH_PORT" >> ${SCRIPT_PATH}/login_information.txt
								echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
								echo "" >> ${SCRIPT_PATH}/login_information.txt
								service sshd restart
								break
						fi
					else
						dialog_msg "The Port should only contain numbers!"
						dialog --clear
					fi
				done
				dialog_msg "Changed SSH Port to $NEW_SSH_PORT"
				source ${SCRIPT_PATH}/script/functions.sh; continue_or_exit
				source ${SCRIPT_PATH}/menus/openssh_menu.sh; menu_options_openssh
				;;
			3)
				dialog_info "Creating new Openssh key"
				source ${SCRIPT_PATH}/script/openssh_options.sh; create_new_openssh_key
				dialog_msg "Finished creating new ssh key"
				echo
				echo
				echo "You can find your New SSH key at ${SCRIPT_PATH}/ssh_privatekey.txt"
				echo
				echo
				echo "Password for your new ssh key = $NEW_SSH_PASS"
				echo
				echo
				echo "Your new SSH Key"
				cat ${SCRIPT_PATH}/ssh_privatekey.txt
				source ${SCRIPT_PATH}/script/functions.sh; continue_or_exit
				source ${SCRIPT_PATH}/menus/openssh_menu.sh; menu_options_openssh
				;;
			4)
				source ${SCRIPT_PATH}/menus/services_menu.sh; menu_options_services
				;;
			5)
				echo "Exit"
				exit 1
				;;
	esac
}
