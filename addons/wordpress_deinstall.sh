#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

deinstall_wordpress() {

MYSQL_ROOT_PASS=$(grep -Pom 1 "(?<=^MYSQL_ROOT_PASS: ).*$" ${SCRIPT_PATH}/login_information.txt)
WORDPRESS_DB_NAME=$(grep -Pom 1 "(?<=^WordpressDBName = ).*$" ${SCRIPT_PATH}/wordpress_login_data.txt)
WordpressDBUser=$(grep -Pom 1 "(?<=^WordpressDBUser = ).*$" ${SCRIPT_PATH}/wordpress_login_data.txt)
WordpressScriptPath=$(grep -Pom 1 "(?<=^WordpressScriptPath = ).*$" ${SCRIPT_PATH}/wordpress_login_data.txt)

mysql -u root -p${MYSQL_ROOT_PASS} -e "DROP DATABASE IF EXISTS ${WORDPRESS_DB_NAME};"
mysql -u root -p${MYSQL_ROOT_PASS} -e "DROP USER ${WordpressDBUser}@localhost;"

if [ "$WORDPRESS_PATH_NAME" != "root" ]; then
  rm -rf /var/www/${MYDOMAIN}/public/${WordpressScriptPath}
else
  rm -R /var/www/${MYDOMAIN}/public/wp-admin/
  rm -R /var/www/${MYDOMAIN}/public/wp-content/
  rm -R /var/www/${MYDOMAIN}/public/wp-includes/
  rm /var/www/${MYDOMAIN}/public/{license.txt,readme.html,wp-activate.php,wp-blog-header.php,wp-config.php,wp-load.php,wp-mail.php,wp-signup.php,xmlrpc.php,index.php,wp-comments-post.php,wp-config-sample.php,wp-cron.php,wp-links-opml.php,wp-login.php,wp-settings.php,wp-trackback.php}
  cp /var/www/${MYDOMAIN}/public/index-files-backup/* /var/www/next-server.eu/public/
  rm -R /var/www/${MYDOMAIN}/public/index-files-backup/
fi

rm ${SCRIPT_PATH}/wordpress_login_data.txt
rm /etc/nginx/_wordpress.conf
sed -i "s/include _wordpress.conf;/#include _wordpress.conf;/g" /etc/nginx/sites-available/${MYDOMAIN}.conf

systemctl -q restart php$PHPVERSION7-fpm.service
service nginx restart

sed -i 's/WORDPRESS_PATH_NAME=".*"/WORDPRESS_PATH_NAME="0"/' ${SCRIPT_PATH}/configs/userconfig.cfg
sed -i 's/WORDPRESS_IS_INSTALLED="1"/WORDPRESS_IS_INSTALLED="0"/' ${SCRIPT_PATH}/configs/userconfig.cfg
}
