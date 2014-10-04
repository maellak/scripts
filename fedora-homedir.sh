#!/bin/bash

# Configures the home directory for Apache.
# Works on Fedora 20.
# Assumes that it has been run as 'root'.

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo Back up userdir.conf
cp /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/userdir.conf.backup

echo Replace userdir.conf from GitHub copy
yum install -y wget
wget https://raw.githubusercontent.com/maellak/scripts/master/userdir.conf -O /etc/httpd/conf.d/userdir.conf

echo Restart Apache
service httpd restart

echo Generate and set up public folder for ellak user
mkdir /home/ellak/public_html
chmod 711 /home/ellak
chown ellak:ellak /home/ellak/public_html
chmod 755 /home/ellak/public_html

echo Set SELinux policies
setsebool -P httpd_enable_homedirs true
chcon -R -t httpd_sys_content_t /home/ellak/public_html
