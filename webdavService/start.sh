echo $WEBDAV
echo "$WEBDAV "`cat /webdav/secret` > ~/.davfs/secrets
cat ~/.davfs/secrets
mkdir mnt_webdav
mount -t davfs $WEBDAV /mnt_webdav 
