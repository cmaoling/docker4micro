############################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM armhfbuild/debian:wheezy

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Create pagemaster container on micro best of my knowledge
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN apt-get install -y inotify-tools

VOLUME /usr/lib/activefolder
ADD activefolder/init.d/ /etc/init.d/
ADD activefolder /usr/lib/activefolder
RUN touch /etc/activefolder
RUN ["/etc/init.d/activefolder","start"]
