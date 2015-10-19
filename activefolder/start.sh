#!/bin/bash

# Start activefolder
addgroup $AF_DEFAULTGROUP 
useradd -G $AF_DEFAULTGROUP -M $AF_ACTIVEUSER
echo "${AF_DESCRIPTION}:${AF_ROOT}" >> /etc/activefolder
if [ ${AF_AUTOSTART} = "yes" ]; then touch ${AF_ROOT}/active; fi
ls $AF_DOER |  sed 's/=/\//g' > ${AF_ROOT}/.include
/etc/init.d/activefolder start
chown -v -R $AF_ACTIVEUSER:$AF_DEFAULTGROUP /activefolder/ >> /srv/activefolder/install
chmod -v u+rws-x /activefolder  >> /srv/activefolder/install
chmod -v g+ws-xr /activefolder  >> /srv/activefolder/install
chmod -v o-rwx /activefolder  >> /srv/activefolder/install
chown -v -R $AF_ACTIVEUSER:$AF_DEFAULTGROUP /activedoer/ >> /srv/activefolder/install
chmod -v -R u+xwr /activedoer >> /srv/activefolder/install
chmod -v -R g+xr-w /activedoer >> /srv/activefolder/install
chmod -v -R o+r-xw /activedoer >> /srv/activefolder/install
ls -la /activearea/.activefolder/log/ >> /srv/activefolder/install
mkdir -p /activearea/.activefolder/log/ >> /srv/activefolder/install
chown -v -R $AF_ACTIVEUSER:$AF_DEFAULTGROUP /activearea/.activefolder/log/ >> /srv/activefolder/install
chmod -v -R u+r-wxs  /activearea/.activefolder/log/ >> /srv/activefolder/install
chmod -v -R g+ws-wx  /activearea/.activefolder/log/ >> /srv/activefolder/install
chmod -v -R o-rwx  /activearea/.activefolder/log/ >> /srv/activefolder/install
tail -f /srv/activefolder/*

