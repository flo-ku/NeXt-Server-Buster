#What you need:

A vServer with at least:
```
- 1 CPU Core
- 1 GB RAM
- KVM virtualized server (Openvz [...] will not work!)
- The latest "clean" Debian 10.x minimal installed on the server (with all updates!)
- rDNS set to the desired Domain
- root user access
- 9 GB free disk space

- IPv4 Adress
- A Domain and the ability to change the DNS Settings
- DNS Settings described in the dns_settings.txt
- Time... the DNS system may need 24 to 48 hours to recognize the changes you made!

- The will to learn something about Linux ;)
```

#Short instructions:

```
cd /root/; apt-get update; apt-get install git -y; git clone https://github.com/shoujii/NeXt-Server-Buster; cd NeXt-Server-Buster; bash nxt.sh
```

Follow the instructions!

#Credits:
```
#Thanks to Thomas Leister and his awesome Mailserver Setup, we're using in this Script!
https://thomas-leister.de/mailserver-debian-stretch/


Also thanks to Michael Thies, for the managevmail script, used for the Mailserver.
https://github.com/mhthies/managevmail
```
