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
ENV DEBIAN_FRONTEND noninteractive
#RUN apt-get -y install libpam-systemd
RUN apt-get -y install openssh-server firefox xvfb
RUN apt-get install -y x11vnc
ENV DISPLAY :99
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]
#http://stackoverflow.com/questions/20811043/trouble-installing-mozrepl and https://groups.google.com/forum/#!topic/mozlab/iq6bStsoCQg
ADD mozrepl/mozrepl.xpi /usr/lib/firefox-addons/extensions/mozrepl@hyperstruct.net.xpi
RUN echo "pref("extensions.mozrepl.autoStart", true);" >> /usr/lib/firefox-addons/extensions/prefs.js
ENV MOZREPL_PORT 4242
#ADD /etc/shadow /shadow
#ENV USER ""
#RUN useradd $USER -p`grep -e"$USER" /etc/shadow | cut -d":" -f2`
#################### INSTALLATION END #####################
