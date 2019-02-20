#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_openssl() {

trap error_exit ERR

source ${SCRIPT_PATH}/configs/versions.cfg

#-4 only working for beta releases -> stable releases -3!
LOCAL_OPENSSL_VERSION_STRING=$(openssl version | awk '/OpenSSL/ {print $(NF-3)}')

if [[ ${LOCAL_OPENSSL_VERSION} != ${OPENSSL_VERSION} ]]; then

	cd ${SCRIPT_PATH}/sources
	wget_tar "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
	tar_file "openssl-${OPENSSL_VERSION}.tar.gz"
	cd openssl-${OPENSSL_VERSION}
	./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic -Wl,-R,'$(LIBRPATH)' -Wl,--enable-new-dtags >>"${make_log}" 2>>"${make_err_log}"
	make -j $(nproc) >>"${make_log}" 2>>"${make_err_log}"
	make install >>"${make_log}" 2>>"${make_err_log}"
	fi
}
