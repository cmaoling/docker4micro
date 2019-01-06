# command to read attached block devices:
blkid
mount -r /dev/sda6 /datalake
cd /etc
cat fstab
cat /datalake/micro/fstab | grep sda >> fstab
cat fstab
cd /root
cp -r /datalake/micro/my-ca .
cp /datalake/micro/ca.pem .
