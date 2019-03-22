#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

menu_options_munin() {

source ${SCRIPT_PATH}/configs/userconfig.cfg
source ${SCRIPT_PATH}/script/functions.sh; get_domain

trap error_exit ERR

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=3
BACKTITLE="NeXt Server"
TITLE="NeXt Server"
MENU="In which path do you want to install Munin?"
OPTIONS=(1 "${MYDOMAIN}/munin"
2 "${MYDOMAIN}/monitoring"
3 "Custom (except root and minimum 2 characters!)")
menu
clear

case $CHOICE in
  1)
    MUNIN_PATH_NAME="munin"
    sed -i 's/MUNIN_PATH_NAME="0"/MUNIN_PATH_NAME="'${MUNIN_PATH_NAME}'"/' ${SCRIPT_PATH}/configs/userconfig.cfg
    ;;
  2)
    MUNIN_PATH_NAME="monitoring"
    sed -i 's/MUNIN_PATH_NAME="0"/MUNIN_PATH_NAME="'${MUNIN_PATH_NAME}'"/' ${SCRIPT_PATH}/configs/userconfig.cfg
    ;;
  3)
      while true
        do
          MUNIN_PATH_NAME=$(dialog --clear \
          --backtitle "$BACKTITLE" \
          --inputbox "Enter the name of Munin installation path. Link after ${MYDOMAIN}/ only A-Z and a-z letters \
          \n\nYour Input should have at least 2 characters or numbers!" \
          $HEIGHT $WIDTH \
          3>&1 1>&2 2>&3 3>&- \
          )
            if [[ "$MUNIN_PATH_NAME" =~ ^[a-zA-Z0-9]+$ ]]; then
              if [ ${#MUNIN_PATH_NAME} -ge 2 ]; then
                array=($(cat "${SCRIPT_PATH}/configs/blocked_paths.conf"))
                printf -v array_str -- ',,%q' "${array[@]}"

                if [[ "${array_str},," =~ ,,${MUNIN_PATH_NAME},, ]]; then
                  dialog_msg "[ERROR] Your Munin path ${MUNIN_PATH_NAME} is already used by the script, please choose another one!"
                  dialog --clear
                else
                  sed -i 's/MUNIN_PATH_NAME="0"/MUNIN_PATH_NAME="'${MUNIN_PATH_NAME}'"/' ${SCRIPT_PATH}/configs/userconfig.cfg
                  break
                fi
              else
                dialog_msg "[ERROR] Your Input should have at least 2 characters or numbers!"
                dialog --clear
              fi
            else
              dialog_msg "[ERROR] Your Input should contain characters or numbers!!"
              dialog --clear
            fi
        done
    ;;
esac
}
