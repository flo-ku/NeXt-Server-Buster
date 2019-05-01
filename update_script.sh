#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_script() {

mkdir -p /root/backup_next_server 
if [ -d "${SCRIPT_PATH}/logs/" ]; then
  mkdir -p /root/backup_next_server/logs
  mv ${SCRIPT_PATH}/logs/* /root/backup_next_server/logs/
fi

if [ -e ${SCRIPT_PATH}/login_information.txt ]; then
  mv ${SCRIPT_PATH}/login_information.txt /root/backup_next_server/
fi

if [ -e ${SCRIPT_PATH}/ssh_privatekey.txt ]; then
  mv ${SCRIPT_PATH}/ssh_privatekey.txt /root/backup_next_server/
fi

if [ -e ${SCRIPT_PATH}/installation_times.txt ]; then
  mv ${SCRIPT_PATH}/installation_times.txt /root/backup_next_server/
fi

if [ -e ${SCRIPT_PATH}/configs/userconfig.cfg ]; then
  mv ${SCRIPT_PATH}/configs/userconfig.cfg /root/backup_next_server/
fi

if [ -e ${SCRIPT_PATH}/DKIM_KEY_ADD_TO_DNS.txt ]; then
  mv ${SCRIPT_PATH}/DKIM_KEY_ADD_TO_DNS.txt /root/backup_next_server/
fi

local_branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
remote=$(git config branch.$local_branch.remote)

dialog_msg "Fetching from ${remote}..."
git fetch $remote

if git merge-base --is-ancestor $remote_branch HEAD; then
    GIT_LOCAL_FILES_HEAD=$(git rev-parse --short HEAD)
    dialog_msg "Already up-to-date Version ${GIT_LOCAL_FILES_HEAD}"
elif [[ git merge-base --is-ancestor HEAD $remote_branch ]]; then
    git stash
    git merge --ff-only --stat $remote_branch
    GIT_LOCAL_FILES_HEAD=$(git rev-parse --short HEAD)
    dialog_msg "Merged to the new Version ${GIT_LOCAL_FILES_HEAD}" 
fi

if [ -d "/root/backup_next_server/logs/" ]; then
  mv /root/backup_next_server/logs/* ${SCRIPT_PATH}/logs/
fi

if [ -e /root/backup_next_server/login_information.txt ]; then
  mv /root/backup_next_server/login_information.txt ${SCRIPT_PATH}/
fi

if [ -e /root/backup_next_server/ssh_privatekey.txt ]; then
  mv /root/backup_next_server/ssh_privatekey.txt ${SCRIPT_PATH}/
fi

if [ -e /root/backup_next_server/installation_times.txt ]; then
  mv /root/backup_next_server/installation_times.txt ${SCRIPT_PATH}/
fi

if [ -e /root/backup_next_server/userconfig.cfg ]; then
  mv /root/backup_next_server/userconfig.cfg ${SCRIPT_PATH}/configs/
fi

if [ -e /root/backup_next_server/DKIM_KEY_ADD_TO_DNS.txt ]; then
  mv /root/backup_next_server/DKIM_KEY_ADD_TO_DNS.txt ${SCRIPT_PATH}/
fi

  rm -R /root/backup_next_server/
}