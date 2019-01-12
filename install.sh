#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

SCRIPT_PATH="/root/NeXt-Server-Buster"

source ${SCRIPT_PATH}/configs/versions.cfg
source ${SCRIPT_PATH}/configs/userconfig.cfg

	set -x

	install_start=`date +%s`
	progress_gauge "0" "Checking your system..."
	source ${SCRIPT_PATH}/script/logs.sh; set_logs
	source ${SCRIPT_PATH}/script/functions.sh
	source ${SCRIPT_PATH}/script/functions.sh; setipaddrvars
	source ${SCRIPT_PATH}/script/checksystem.sh; check_system

	source ${SCRIPT_PATH}/confighelper.sh; confighelper_userconfig

	system_end=`date +%s`
	systemtime=$((system_end-install_start))

  system_start=`date +%s`
	progress_gauge "0" "Installing System..."
	source ${SCRIPT_PATH}/script/system.sh; install_system
	system_end=`date +%s`
	systemtime=$((system_end-system_start))

	openssl_start=`date +%s`
	progress_gauge "1" "Installing OpenSSL..."
	source ${SCRIPT_PATH}/script/openssl.sh; install_openssl
	openssl_end=`date +%s`
	openssltime=$((openssl_end-openssl_start))

	openssh_start=`date +%s`
	progress_gauge "31" "Installing OpenSSH..."
	source ${SCRIPT_PATH}/script/openssh.sh; install_openssh
	openssh_end=`date +%s`
	opensshtime=$((openssh_end-openssh_start))

	fail2ban_start=`date +%s`
	progress_gauge "32" "Installing fail2ban..."
	source ${SCRIPT_PATH}/script/fail2ban.sh; install_fail2ban
	fail2ban_end=`date +%s`
	fail2bantime=$((fail2ban_end-fail2ban_start))

	mariadb_start=`date +%s`
	progress_gauge "33" "Installing MariaDB..."
	source ${SCRIPT_PATH}/script/mariadb.sh; install_mariadb
	maria_end=`date +%s`
	mariatime=$((maria_end-mariadb_start))

	nginx_start=`date +%s`
	progress_gauge "34" "Installing Nginx Addons..."
	source ${SCRIPT_PATH}/script/nginx_addons.sh; install_nginx_addons

	progress_gauge "40" "Installing Nginx..."
	source ${SCRIPT_PATH}/script/nginx.sh; install_nginx

	progress_gauge "65" "Installing Let's Encrypt..."
	source ${SCRIPT_PATH}/script/lets_encrypt.sh; install_lets_encrypt
	progress_gauge "68" "Creating Let's Encrypt Certificate..."
	source ${SCRIPT_PATH}/script/lets_encrypt.sh; create_nginx_cert

	progress_gauge "74" "Installing PHP..."
	php_start=`date +%s`
	if [[ ${USE_PHP7_2} = "1" ]]; then
		source ${SCRIPT_PATH}/script/php7_2.sh; install_php_7_2
	fi

	if [[ ${USE_PHP7_3} = "1" ]]; then
		source ${SCRIPT_PATH}/script/php7_3.sh; install_php_7_3
	fi
	php_end=`date +%s`
	phptime=$((php_end-php_start))

	progress_gauge "75" "Installing Mailserver..."
	mailserver_start=`date +%s`
	if [[ ${USE_MAILSERVER} = "1" ]]; then
		source ${SCRIPT_PATH}/script/unbound.sh; install_unbound
		source ${SCRIPT_PATH}/script/mailserver.sh; install_mailserver
		source ${SCRIPT_PATH}/script/dovecot.sh; install_dovecot
		source ${SCRIPT_PATH}/script/postfix.sh; install_postfix
		source ${SCRIPT_PATH}/script/rspamd.sh; install_rspamd
		source ${SCRIPT_PATH}/script/rainloop.sh; install_rainloop
		source ${SCRIPT_PATH}/script/managevmail.sh; install_managevmail
	fi
	mailserver_end=`date +%s`
	mailservertime=$((mailserver_end-mailserver_start))

	firewall_start=`date +%s`
	progress_gauge "96" "Installing Firewall..."
	source ${SCRIPT_PATH}/script/firewall.sh; install_firewall
	firewall_end=`date +%s`
	firewalltime=$((firewall_end-firewall_start))

	install_end=`date +%s`
	runtime=$((install_end-install_start))

	touch ${SCRIPT_PATH}/installation_times.txt
	install_runtime_string="NeXt Server Installation runtime for"
	echo "----------------------------------------------------------------------------------------" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string System preparation in seconds: ${systemtime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string SSL in seconds: ${openssltime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string SSH in seconds: ${opensshtime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string fail2ban in seconds: ${fail2bantime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string MariaDB in seconds: ${mariatime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string Nginx in seconds: ${nginxtime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string PHP in seconds: ${phptime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string Mailserver in seconds: ${mailservertime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string Firewall in seconds: ${firewalltime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "$install_runtime_string the whole Installation seconds: ${runtime}" >> ${SCRIPT_PATH}/installation_times.txt
	echo "----------------------------------------------------------------------------------------" >> ${SCRIPT_PATH}/installation_times.txt
	echo "" >> ${SCRIPT_PATH}/installation_times.txt

	if [[ ${USE_MAILSERVER} = "1" ]]; then
		sed -i 's/NXT_IS_INSTALLED_MAILSERVER="0"/NXT_IS_INSTALLED_MAILSERVER="1"/' ${SCRIPT_PATH}/configs/userconfig.cfg
	else
		sed -i 's/NXT_IS_INSTALLED="0"/NXT_IS_INSTALLED="1"/' ${SCRIPT_PATH}/configs/userconfig.cfg
	fi

	date=$(date +"%d-%m-%Y")
	sed -i 's/NXT_INSTALL_DATE="0"/NXT_INSTALL_DATE="'${date}'"/' ${SCRIPT_PATH}/configs/userconfig.cfg

	# Start Full Config after installation
	source ${SCRIPT_PATH}/script/configuration.sh; start_after_install
