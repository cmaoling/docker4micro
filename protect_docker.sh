# based on https://docs.docker.com/engine/security/https/#create-a-ca-server-and-client-keys-with-openssl
service docker stop
# service-side
cd my-ca
dockerd --tlsverify --tlscacert=ca-root.pem --tlscert=docker-pub.pem --tlskey=docker-key.pem -H=0.0.0.0:2376 &
#persistence:
# https://linuxconfig.org/how-to-move-docker-s-default-var-lib-docker-to-another-directory-on-ubuntu-debian-linux
nano /lib/systemd/system/docker.service 
ExecStart=/usr/bin/dockerd --tlsverify --tlscacert=/root/my-ca/ca-root.pem --tlscert=/root/my-ca/docker-pub.pem --tlskey=/root/my-ca/docker-key.pem --data-root /docker -H=0.0.0.0:2376
systemctl daemon-reload
service docker start
#validate
ps aux | grep -i docker | grep -v grep

#client-side
HOST=<secret>
mkdir -pv ~/.docker
cp ca-root.pem ~/.docker
export DOCKER_HOST=tcp://$HOST:2376 DOCKER_TLS_VERIFY=1
#persistent with
echo "DOCKER_HOST=tcp://"`cat /etc/hostname`":2376"
echo "DOCKER_TLS_VERIFY=1" >> /etc/environment
