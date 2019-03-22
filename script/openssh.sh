#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_openssh() {

trap error_exit ERR

mkdir -p /etc/ssh
install_packages "libpam-dev openssh-server"

#cd ${SCRIPT_PATH}/sources
#wget_tar "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz"
#tar_file "openssh-${OPENSSH_VERSION}.tar.gz"
#cd openssh-${OPENSSH_VERSION}

#./configure --prefix=/usr --with-pam --with-zlib --with-ssl-engine --with-ssl-dir=/etc/ssl --sysconfdir=/etc/ssh >>"${main_log}" 2>>"${err_log}"
#make -j $(nproc) >>"${main_log}" 2>>"${err_log}"
#mv /etc/ssh{,.bak}
#make install >>"${main_log}" 2>>"${err_log}"

cp ${SCRIPT_PATH}/configs/sshd_config /etc/ssh/sshd_config
cp ${SCRIPT_PATH}/includes/issue /etc/issue
cp ${SCRIPT_PATH}/includes/issue.net /etc/issue.net

array=($(cat "${SCRIPT_PATH}/configs/blocked_ports.conf"))
printf -v array_str -- ',,%q' "${array[@]}"

	while true
	do
	RANDOM_SSH_PORT="$(($RANDOM % 1023))"
		if [[ "${array_str},," =~ ,,${RANDOM_SSH_PORT},, ]]
			echo "Random Openssh Port is used by the system, creating new one"
		else
			SSH_PORT="$RANDOM_SSH_PORT"
			break
		fi
	done

sed -i "s/^Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
echo "$SSH_PORT" >> ${SCRIPT_PATH}/configs/blocked_ports.conf

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "#SSH_PORT: ${SSH_PORT}" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt

SSH_PASS=$(password)

echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "#SSH_PASS: ${SSH_PASS}" >> ${SCRIPT_PATH}/login_information.txt
echo "#------------------------------------------------------------------------------#" >> ${SCRIPT_PATH}/login_information.txt
echo "" >> ${SCRIPT_PATH}/login_information.txt

ssh-keygen -f ~/ssh.key -t ed25519 -N ${SSH_PASS} >>"${main_log}" 2>>"${err_log}"
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cat ~/ssh.key.pub > ~/.ssh/authorized_keys2 && rm ~/ssh.key.pub
chmod 600 ~/.ssh/authorized_keys2
mv ~/ssh.key ${SCRIPT_PATH}/ssh_privatekey.txt

groupadd ssh-user
usermod -a -G ssh-user root

truncate -s 0 /var/log/daemon.log
truncate -s 0 /var/log/syslog

service sshd restart
}
