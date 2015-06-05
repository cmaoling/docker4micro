#!/bin/bash
#
# Copyright (c) 2015 Colinas Maoling colinas.maoling@t-ol.de
#
# assumes OLIMEX micro booted based on 
#    http://mirror.igorpecovnik.com/Micro_Debian_1.8_wheezy_4.0.4.zip
MACHINE=$(uname -m)
KERNEL=$(ls -l /boot/ |grep zImage |awk '{print $NF}')
if [[ $KERNEL == *"4.0"* && $MACHINE == "armv7"* ]]; then
        # There is no NAND support in mainline yet
        echo "Found valid kernel and machine"
        curl -L  https://raw.githubusercontent.com/cmaoling/cgroupfs-mount/master/cgroupfs-mount
else
        echo "Invalid kernel $KERNEL or architecture $MACHINE"
fi


