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

RUN addgroup pagemaster
VOLUME /srv/samba/share/pagemaster
RUN chmod g+rws /srv/samba/share/pagemaster
ADD	pagemaster /srv/samba/share/pagemaster/.activefolder
RUN touch /srv/samba/share/pagemaster/active
RUN echo "pagemaster:/srv/samba/share/pagemaster" >> /etc/activefolder

RUN apt-get install -y samba-common samba gettext
RUN ls -la /etc/samba/smb.conf 
RUN echo "" >> /etc/samba/smb.conf 

RUN find /srv
ADD	share.tmpl /share.tmpl
ADD	setup.sh /setup.sh
RUN chmod 755  /setup.sh

# Ports: https://wiki.samba.org/index.php/Samba_port_usage
#NetBIOS Name Service 	137 	udp
#NetBIOS Datagram 	138 	udp
#NetBIOS Session 	139 	tcp
#(LDAP 	389 	tcp/udp)
#SMB over TCP 	445 	tcp 
EXPOSE 137
EXPOSE 138
EXPOSE 139
EXPOSE 445

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
ENTRYPOINT exec /start.sh
