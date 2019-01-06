# based on https://docs.docker.com/install/linux/docker-ce/ubuntu/
echo "Upgrade from previous docker-io to docker-maintained docker-ce"
apt-get -y remove docker docker-engine docker.io
apt-get -y autoremove
docker --version
#echo "deb [arch=armhf] https://download.docker.com/linux/ubuntu jessie stable" > /etc/apt/sources.list.d/docker.list
#echo "deb [arch=armhf] https://download.docker.com/linux/debian $(lsb_release -cs) stable" |     sudo tee /etc/apt/sources.list.d/docker.list
# cat /etc/apt/sources.list.d/docker.list
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-get -y update
apt-get -y install docker-ce
docker --version
#mkdir /sys/fs/cgroup/systemd
#mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd

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
