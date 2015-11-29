#!/bin/bash
#
# Copyright (c) 2015 Colinas Maoling colinas.maoling@t-ol.de
#
# assumes OLIMEX micro booted based on 
#    http://mirror.igorpecovnik.com/Micro_Debian_1.8_wheezy_4.0.4.zip
MACHINE=$(uname -m)
KERNEL=$(uname -r | cut -d. -f1-2)
echo "Kernel=$KERNEL Machine=$MACHINE"
if (( $(bc <<< "$KERNEL >= 3.8") == 1 )); then
    if [[ $MACHINE == "armv7"* ]]; then
        echo "Found valid kernel and architecture"
        # Add repro for docker  
        touch /etc/apt/sources.list.d/docker.list
        rm /etc/apt/sources.list.d/docker.list
        echo 'deb http://ftp.de.debian.org/debian sid main' >> /etc/apt/sources.list.d/docker.list
        # Reload all
        apt-get update
        apt-get autoremove
        # FIX: Setting locale failed.
        apt-get install -y locales
        # install Linux Extended Container
        apt-get install -y lxc
        # install AU-AFS
        apt-get install -y cgroup-bin aufs-tools
        apt-get install -y docker.io
        # mount cgroups
        echo "curl -L  https://raw.githubusercontent.com/cmaoling/cgroupfs-mount/master/cgroupfs-mount | /bin/bash" >> /etc/default/docker
        #docker-compose based on :http://blog.hypriot.com/post/docker-compose-nodejs-haproxy/
        sh -c "curl -L https://github.com/hypriot/compose/releases/download/1.1.0-raspbian/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose"
        . /etc/default/docker
        mount
        sysctl -w net.ipv4.ip_forward=1
        # check install
        lxc-checkconfig
        curl -L https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh | /bin/bash /dev/stdin
        #docker -D -d &
        docker run -it armhfbuild/debian:latest uname -a
        docker ps -a
        docker images
     else 
        echo "Valid kernel $KERNEL on invalid architecture $MACHINE"
     fi
elif [[ $MACHINE == "armv7"* ]]; then
        echo "Invalid kernel $KERNEL on valid architecture $MACHINE"
else
        echo "Invalid kernel $KERNEL and architecture $MACHINE"
fi


