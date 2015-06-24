############################################################
# Dockerfile to build firefox container images
# Based on armhf-debian
FROM mazzolino/armhf-ubuntu:14.04

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Install APACHE2 on micro best of my knowledge
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
#http://security.stackexchange.com/questions/61710/how-to-sandbox-iceweasel-firefox-on-debian
RUN apt-get -y install libpam-systemd
RUN apt-get -y install openssh-server firefox xvfb
#RUN apt-get install -y x11vnc xvfb firefox
#ADD /etc/shadow /shadow
#ENV USER ""
#RUN useradd $USER -p`grep -e"$USER" /etc/shadow | cut -d":" -f2`
#################### INSTALLATION END #####################
