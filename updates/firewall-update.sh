#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_firewall() {

	trap error_exit ERR

	apt-get update
}
