############################################################
# Dockerfile to build  images
# Based on armhf-debian
FROM colinas/activefolder

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Create pagemaster container on micro best of my knowledge
ENV DEBIAN_FRONTEND "noninteractive"

#RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
USER root
RUN apt-get install -y samba-common samba gettext
# Ports: https://wiki.samba.org/index.php/Samba_port_usage
#NetBIOS Name Service   137     udp
#NetBIOS Datagram       138     udp
#NetBIOS Session        139     tcp
#(LDAP  389     tcp/udp)
#SMB over TCP   445     tcp
EXPOSE 137 138 139 445

ADD share.tmpl /share.tmpl
VOLUME /srv/samba/share
ADD doer/ $AF_DOER
ADD start.sh /smb-start.sh

ENV SMB_DEFAULTGROUP sambashare

RUN groups  $AF_ACTIVEUSER 
RUN usermod -a -G $SMB_DEFAULTGROUP  $AF_ACTIVEUSER 
RUN chmod 0755 /smb-start.sh

ENTRYPOINT exec /smb-start.sh
