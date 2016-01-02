#!/bin/bash
export WEBDAV=${WEBDAV:-"https://deadbeef.nil"}
echo $WEBDAV
if [ -e /webdav/secret ]; then 
  echo "$WEBDAV "`cat /webdav/secret` > ~/.davfs/secrets
  cat ~/.davfs/secrets
  mkdir mnt_webdav
  mount -t davfs $WEBDAV /mnt_webdav 
  top
else
  echo "No secret provided."
fi
