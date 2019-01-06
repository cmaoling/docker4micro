# based on https://docs.docker.com/engine/security/https/#create-a-ca-server-and-client-keys-with-openssl
# service-side
cd my-ca
dockerd --tlsverify --tlscacert=ca-root.pem --tlscert=docker-pub.pem --tlskey=docker-key.pem -H=0.0.0.0:2376 &

#client-side
HOST=<secret>
mkdir -pv ~/.docker
cp ca-root.pem ~/.docker
export DOCKER_HOST=tcp://$HOST:2376 DOCKER_TLS_VERIFY=1
