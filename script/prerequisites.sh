#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

prerequisites() {

trap error_exit ERR

install_packages "build-essential dbus libcrack2 dnsutils netcat automake autoconf gawk lsb-release"
}
