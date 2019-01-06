#!/bin/bash
#
# Copyright (c) 2015 Colinas Maoling colinas.maoling@t-ol.de
#
# assumes OLIMEX micro booted based on 
#    http://mirror.igorpecovnik.com/Micro_Debian_1.8_wheezy_4.0.4.zip
MACHINE=$(uname -m)
KERNEL=$(uname -r | cut -d. -f1-2)
echo "Kernel=$KERNEL Machine=$MACHINE"
if (( $(bc <<< "$KERNEL >= 4.14") == 1 )); then
    if [[ $MACHINE == "armv7"* ]]; then
        echo "Found valid kernel and architecture"
        # Add repro for docker  
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        echo "deb [arch=armhf] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        # Reload all
        apt-get update
        apt-get autoremove
        # FIX: Setting locale failed.
        apt-get install -y locales
        # install AU-AFS
        apt-get install -y aufs-tools
        apt-get -y install docker-ce
        docker --version
        sysctl -w net.ipv4.ip_forward=1
        # check install
        docker --version
        docker ps -a
        docker images
        cat /sys/power/axp_pmu/battery/capacity
        echo "HOST="`cat /etc/hostname` >> /etc/environment
     else 
        echo "Valid kernel $KERNEL on invalid architecture $MACHINE"
     fi
elif [[ $MACHINE == "armv7"* ]]; then
        echo "Invalid kernel $KERNEL on valid architecture $MACHINE"
else
        echo "Invalid kernel $KERNEL and architecture $MACHINE"
fi


