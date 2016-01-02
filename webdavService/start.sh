#!/bin/bash
ls -la /webdav
if [ -e /webdav/secret ]; then
  MNT=`cat /webdav/secret  | cut -d" " -f1`
  SERVER=`cat /webdav/secret  | cut -d" " -f2`
  cat /webdav/secret  | cut -d" " -f2- > /etc/davfs2/secrets
  cat /etc/davfs2/secrets
  mkdir /mnt_webdav
  mkdir /mnt_webdav/$MNT
  mount -t davfs $SERVER /mnt_webdav/$MNT
else
  echo "No secret provided."
fi
tail -f /var/log/bootstrap.log
