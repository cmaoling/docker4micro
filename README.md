# docker4micro
base on http://www.igorpecovnik.com/2014/11/18/olimex-lime-debian-sd-image/
repository to enable docker based on this image

Transfer on SD Card:
clean SD card using gparted by creating a fresh ext4 partition, then
sudo dd bs=1M if=Micro_Debian_1.8_wheezy_4.0.4.raw of=/dev/sdx

usage of bootstrab
 curl -L --ssh https://raw.githubusercontent.com/cmaoling/docker4micro/master/bootstrap.sh | /bin/bash
