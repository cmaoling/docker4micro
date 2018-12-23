# based on https://docs.docker.com/install/linux/docker-ce/ubuntu/
echo "Upgrade from previous docker-io to docker-maintained docker-ce"
apt-get remove docker docker-engine docker.io
docker --version
echo "deb [arch=armhf] https://download.docker.com/linux/ubuntu jessie stable" > /etc/apt/sources.list.d/docker.list
# cat /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install docker-ce
docker --version
