#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

install_unbound() {

trap error_exit ERR

install_packages "unbound dnsutils"

#IPv4 workaround
rm /etc/unbound/unbound.conf
cp /usr/share/doc/unbound/examples/unbound.conf /etc/unbound/unbound.conf
sed -i "s/# interface: 192.0.2.153/  interface: 127.0.0.1/g" /etc/unbound/unbound.conf
sed -i "s/# control-interface: 127.0.0.1/  control-interface: 127.0.0.1/g" /etc/unbound/unbound.conf

sudo -u  unbound unbound-anchor -a /var/lib/unbound/root.key
systemctl stop unbound

systemctl start unbound

install_packages "resolvconf"
echo "nameserver 127.0.0.1" >> /etc/resolvconf/resolv.conf.d/head

}
