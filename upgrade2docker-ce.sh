# based on https://docs.docker.com/install/linux/docker-ce/ubuntu/
echo "Upgrade from previous docker-io to docker-maintained docker-ce"
apt-get -y remove docker docker-engine docker.io
apt-get -y autoremove
docker --version
echo "deb [arch=armhf] https://download.docker.com/linux/ubuntu jessie stable" > /etc/apt/sources.list.d/docker.list
# cat /etc/apt/sources.list.d/docker.list
apt-get -y update
apt-get -y install docker-ce
docker --version
