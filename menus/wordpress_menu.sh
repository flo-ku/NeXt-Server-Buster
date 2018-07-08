#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

menu_options_wordpress() {

source ${SCRIPT_PATH}/script/functions.sh; get_domain

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=5
BACKTITLE="NeXt Server"
TITLE="NeXt Server"
CHOICE_HEIGHT=3
MENU="In which path do you want to install Wordpress?"
OPTIONS=(1 "${MYDOMAIN}/wordpress"
2 "${MYDOMAIN}/blog"
3 "Custom (except root and minimum 2 characters!)")
menu
clear

case $CHOICE in
  1)
    WORDPRESS_PATH_NAME="wordpress"
    ;;
  2)
    WORDPRESS_PATH_NAME="blog"
    ;;
  3)
      while true
        do
          WORDPRESS_PATH_NAME=$(dialog --clear \
          --backtitle "$BACKTITLE" \
          --inputbox "Enter the name of Wordpress installation path. Link after ${MYDOMAIN}/ only A-Z and a-z letters \
          \n\nYour Input should have at least 2 characters or numbers!" \
          $HEIGHT $WIDTH \
          3>&1 1>&2 2>&3 3>&- \
          )
            if [[ "$WORDPRESS_PATH_NAME" =~ ^[a-zA-Z0-9]+$ ]]; then
              if [ ${#WORDPRESS_PATH_NAME} -ge 1 ]; then
                  break
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
