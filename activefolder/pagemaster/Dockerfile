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
RUN apt-get install -y samba-common samba gettext
RUN ls -la /etc/samba/smb.conf 
RUN echo "" >> /etc/samba/smb.conf 

RUN find /srv
ADD		share.tmpl /share.tmpl
ADD		setup.sh /setup.sh
RUN chmod 755  /setup.sh

RUN addgroup pagemaster
VOLUME /srv/samba/share/pagemaster
RUN chmod g+rws /srv/samba/share/pagemaster
RUN echo "pagemaster:/pagemaster" >> /etc/activefolder
RUN /etc/init.d/samba start
RUN echo "watching /var/log/samba/*"
RUN	tail -f /var/log/samba/*
EXPOSE 137
EXPOSE 138
EXPOSE 139
EXPOSE 445
