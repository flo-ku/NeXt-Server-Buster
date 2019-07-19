#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

patch_rspamd_dkim() {

trap error_exit ERR


SELECTOR=$(grep "selector.*=.*\".*\";" /etc/rspamd/local.d/dkim_signing.conf | sed "s/^selector.*=.*\"\(.*\)\";$/\1/")
BKUPP="/root/nxt-backup/rspamd-dkim-fix"

if grep --quiet "BEGIN PRIVATE KEY" ${SCRIPT_PATH}/DKIM_KEY_ADD_TO_DNS.txt && \
   grep --quiet "BEGIN PRIVATE KEY" /var/lib/rspamd/dkim/${SELECTOR}.key && \
   grep --quiet "BEGIN PRIVATE KEY" /var/lib/rspamd/dkim/${SELECTOR}.txt; then

    systemctl stop rspamd

    mkdir -p "${BKUPP}"
    cp /var/lib/rspamd/dkim/${SELECTOR}.* "${BKUPP}/"
    cp ${SCRIPT_PATH}/DKIM_KEY_ADD_TO_DNS.txt "${BKUPP}/"
    chmod 600 -R "${BKUPP}"

    rspamadm dkim_keygen -b 2048 -s ${SELECTOR} -k /var/lib/rspamd/dkim/${SELECTOR}.key > /var/lib/rspamd/dkim/${SELECTOR}.txt
    chown -R _rspamd:_rspamd /var/lib/rspamd/dkim
    chmod 440 /var/lib/rspamd/dkim/*
    cp /var/lib/rspamd/dkim/${SELECTOR}.txt ${SCRIPT_PATH}/DKIM_KEY_ADD_TO_DNS.txt

    systemctl start rspamd
fi

}