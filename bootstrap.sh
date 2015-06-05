#!/bin/bash
#
# Copyright (c) 2015 Colinas Maoling colinas.maoling@t-ol.de
#
# assumes OLIMEX micro booted based on 
#    http://mirror.igorpecovnik.com/Micro_Debian_1.8_wheezy_4.0.4.zip
MACHINE=$(uname -m)
KERNEL=$(uname -r)
if [[ $KERNEL >= 3.8 && $MACHINE == "armv7"* ]]; then
        echo "Found valid kernel and machine"
        # Add repro for docker  
        echo 'deb  deb http://ftp.de.debian.org/debian sid main' | tee /etc/apt/sources.list.d/docker.list
        # Reload all
        apt-get update
        # install Linux Extended Container
        apt-get install lxc
        # install AU-AFS
        apt-get install cgroup-bin aufs-tools
        apt-get install docker.io
        # mount cgroups
        curl -L  https://raw.githubusercontent.com/cmaoling/cgroupfs-mount/master/cgroupfs-mount | /bin/bash
        mount
        sysctl -w net.ipv4.ip_forward=1
        # check install
        lxc-checkconfig
        curl -L https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh | /bin/bash /dev/stdin
        #docker -D -d &
        docker run -it armhfbuild/debian:latest | wget www.github.com
else
        echo "Invalid kernel $KERNEL and/or architecture $MACHINE"
fi

