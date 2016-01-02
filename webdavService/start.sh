echo $WEBDAV
if [ -e /webdav/secret ]; then 
  echo "$WEBDAV "`cat /webdav/secret` > ~/.davfs/secrets
  cat ~/.davfs/secrets
  mkdir mnt_webdav
  mount -t davfs $WEBDAV /mnt_webdav 
else
  echo "No secret provided."
fi
