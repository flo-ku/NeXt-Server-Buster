#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
# thx to https://gist.github.com/bgallagh3r
#-------------------------------------------------------------------------------------------------------------

deinstall_nextcloud() {

rm -r /srv/nextcloud/
rm /etc/nginx/html/${MYDOMAIN}/nextcloud
rm /etc/nginx/sites-custom/nextcloud.conf

service nginx restart

}
