#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_roundcube() {

mkdir -p /var/www/${MYDOMAIN}/public/webmail
cd /var/www/${MYDOMAIN}/public/
wget_tar "https://codeload.github.com/roundcube/roundcubemail/zip/${ROUNDCUBE_VERSION}"
unzip_file "${ROUNDCUBE_VERSION}.zip -d /var/www/${MYDOMAIN}/public/webmail"
rm ${ROUNDCUBE_VERSION}.zip

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "Roundcube Webmail URL: https://${MYDOMAIN}/webmail/" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt
}
