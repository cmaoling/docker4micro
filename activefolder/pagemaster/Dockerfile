############################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM colinas/activefolder

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Create pagemaster container on micro best of my knowledge
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN sudo apt-get install -y samba-common samba 
RUN ls -la /etc/samba/smb.conf 
RUN echo "" >> /etc/samba/smb.conf 
RUN addgroup pagemaster
VOLUME /pagemaster
RUN chmod g+rws /pagemaster
RUN echo "pagemaster:/pagemaster" >> /etc/activefolder
