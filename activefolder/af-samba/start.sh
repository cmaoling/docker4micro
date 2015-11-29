#!/bin/bash
. /af-start.sh
export READONLY=${READONLY:-"no"}
export LOCKING=${LOCKING:-"no"}
export GUESTOK=${GUESTOK:-"no"}
export FORCEUSER=${FORCEUSER:-"dummy"}
export FORCEGROUP=${FORCEGROUP:-"none"}
export BROWSABLE=${BROWSABLE:-"no"}
export FILEMOD=${FILEMOD:-0755}
export DIRMOD=${DIRMOD:-0755}
export MASKMOD=${MASKMOD:-0755}
export MAPARCHIVE=${MAPARCHIVE:-"no"}
export MAPSYSTEM=${MAPSYSTEM:-"no"}
export MAPHIDDEN=${MAPHIDDEN:-"no"}
export WORKGROUP=${WORKGROUP:-"WORKGROUP"}

#usermod -a -G $SMB_DEFAULTGROUP  $AF_ACTIVEUSER

echo "workgroup = $WORKGROUP
server string = %h server (Samba, Ubuntu)
security = user
encrypt passwords = true
invalid users = root
" >> /etc/samba/smb.conf
chmod 700 /etc/samba/smbpasswd
for vol in $VOLUMES; do
  echo "add $vol" >> /srv/install
  export VOLUME=$vol
  export VOLUME_NAME=$(echo "$VOLUME" |sed "s/\///" |tr '[\/<>:"\\|?*+;,=]' '_')
  cat /share.tmpl | envsubst >> /etc/samba/smb.conf
done
testparm -s /etc/samba/smb.conf > /etc/samba/smb.conf
/etc/init.d/samba start
netstat -tulpn | egrep "samba|smbd|nmbd|winbind" >> /srv/activefolder/install
echo "$AF_ACTIVEUSER ALL = (ALL:ALL) NOPASSWD: /usr/bin/sudo
$AF_ACTIVEUSER ALL = (ALL:ALL) NOPASSWD: /usr/bin/passwd
$AF_ACTIVEUSER ALL = (ALL:ALL) NOPASSWD: /usr/bin/smbpasswd
$AF_ACTIVEUSER ALL = (ALL:ALL) NOPASSWD: /usr/sbin/groupadd
$AF_ACTIVEUSER ALL = (ALL:ALL) NOPASSWD: /usr/sbin/useradd" >> /etc/sudoers
touch -a /activefolder/*
ping -i 600 localhost
