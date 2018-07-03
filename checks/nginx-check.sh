#!/bin/bash
# Compatible with Debian 10.x Buster
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

check_nginx() {

if [ -e /etc/init.d/nginx ]; then
  echo "${ok} nginx init does exist"
else
  echo "${error} nginx init does NOT exist"
fi

if [ -e /etc/nginx/nginx.conf ]; then
  echo "${ok} nginx.conf does exist"
else
  echo "${error} nginx.conf does NOT exist"
fi

if [ -e /etc/nginx/_general.conf ]; then
  echo "${ok} _general.conf does exist"
else
  echo "${error} _general.conf does NOT exist"
fi

if [ -e /etc/nginx/_letsencrypt.conf ]; then
  echo "${ok} _letsencrypt.conf does exist"
else
  echo "${error} _letsencrypt.conf does NOT exist"
fi

if [ -e /etc/nginx/_pagespeed.conf ]; then
  echo "${ok} _pagespeed.conf does exist"
else
  echo "${error} _pagespeed.conf does NOT exist"
fi

if [ -e /etc/nginx/_php_fastcgi.conf ]; then
  echo "${ok} _php_fastcgi.conf does exist"
else
  echo "${error} _php_fastcgi.conf does NOT exist"
fi

if [ -e /etc/nginx/_php.conf ]; then
  echo "${ok} _php.conf does exist"
else
  echo "${error} _php.conf does NOT exist"
fi

if [ -e /etc/nginx/_brotli.conf ]; then
  echo "${ok} _brotli.conf does exist"
else
  echo "${error} _brotli.conf does NOT exist"
fi

if [ -e etc/nginx/html/${MYDOMAIN}/NeXt-logo.jpg ]; then
  echo "${ok} NeXt-logo.jpg does exist"
else
  echo "${error} NeXt-logo.jpg does NOT exist"
fi

if [ -e /etc/nginx/html/${MYDOMAIN}/index.html ]; then
  echo "${ok} index.html does exist"
else
  echo "${error} index.html does NOT exist"
fi

if [ -e /etc/nginx/sites-enabled/${MYDOMAIN}.conf ]; then
  echo "${ok} /sites-enabled/${MYDOMAIN}.conf does exist"
else
  echo "${error} /sites-enabled/${MYDOMAIN}.conf does NOT exist"
fi

if [ -e /etc/nginx/sites-available/${MYDOMAIN}.conf ]; then
  echo "${ok} /sites-available/${MYDOMAIN}.conf does exist"
else
  echo "${error} /sites-available/${MYDOMAIN}.conf does NOT exist"
fi

#check website
curl ${MYDOMAIN} -s -f -o /dev/null && echo "${ok} Website ${MYDOMAIN} is up and running." || echo "${error} Website ${MYDOMAIN} is down."

#check process
if pgrep -x "nginx" > /dev/null
then
    echo "${ok} Nginx is running"
else
    echo "${error} Nginx STOPPED"
fi

#check version
command="nginx -v"
nginxv=$( ${command} 2>&1 )
nginxlocal=$(echo $nginxv | grep -o '[0-9.]*$')

if [ $nginxlocal != ${NGINX_VERSION} ]; then
  echo "${error} The installed Nginx Version $nginxlocal is DIFFERENT with the Nginx Version ${NGINX_VERSION} defined in the Userconfig!"
else
	echo "${ok} The Nginx Version $nginxlocal is equal with the Nginx Version ${NGINX_VERSION} defined in the Userconfig!"
fi

#check config
nginx -t >/dev/null 2>&1
ERROR=$?
if [ "$ERROR" = '0' ]; then
  echo "${ok} The Nginx Config is working."
else
  echo "${error} The Nginx Config is NOT working."
fi
}
