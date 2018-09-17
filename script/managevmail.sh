#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------


install_managevmail() {

install_packages "python3 python3-mysql.connector"

mkdir -p /etc/managevmail/
wget https://codeload.github.com/mhthies/managevmail/zip/master
unzip master -d /etc/managevmail/

}
