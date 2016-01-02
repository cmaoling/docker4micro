#!/bin/bash
export WEBDAV=${WEBDAV:-"https://deadbeef.nil"}
echo $WEBDAV
ls -la /webdav
if [ -e /webdav/secret ]; then 
  echo "$WEBDAV "`cat /webdav/secret` >> /etc/davfs2/secrets
  cat ~/.davfs/secrets
  mkdir mnt_webdav
  mount -t davfs $WEBDAV /mnt_webdav
else
  echo "No secret provided."
fi
tail -f /var/log/bootstrap.log
