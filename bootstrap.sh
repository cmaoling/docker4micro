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
        echo "\\033[1;32mFound valid kernel and architecture"
        # Add repro for docker  
        touch /etc/apt/sources.list.d/docker.list
        rm /etc/apt/sources.list.d/docker.list
        echo 'deb http://ftp.de.debian.org/debian sid main' >> /etc/apt/sources.list.d/docker.list
        # Reload all
        apt-get update
        apt-get autoremove
        # install Linux Extended Container
        apt-get install -y lxc
        # install AU-AFS
        apt-get install -y cgroup-bin aufs-tools
        apt-get install -y docker.io
        # mount cgroups
        curl -L  https://raw.githubusercontent.com/cmaoling/cgroupfs-mount/master/cgroupfs-mount | /bin/bash
        mount
        sysctl -w net.ipv4.ip_forward=1
        # check install
        lxc-checkconfig
        curl -L https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh | /bin/bash /dev/stdin
        #docker -D -d &
        docker run -it armhfbuild/debian:latest curl -L  https://raw.githubusercontent.com/cmaoling/docker4micro/master/success | /bin/bash
     else 
        echo "Valid kernel $KERNEL on invalid architecture $MACHINE"
     fi
elif [[ $MACHINE == "armv7"* ]]; then
        echo "Invalid kernel $KERNEL on valid architecture $MACHINE"
else
        echo "Invalid kernel $KERNEL and architecture $MACHINE"
fi


