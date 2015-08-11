############################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM armhfbuild/debian:wheezy

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Install owncloud on micro best of my knowledge
ADD deb.list /etc/apt/sources.list.d/owncloud.list 
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN /bin/bash -c "wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key | apt-key add"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y owncloud
