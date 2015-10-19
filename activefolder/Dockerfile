############################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM armhfbuild/debian:wheezy

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
ENV DEBIAN_FRONTEND "noninteractive"

USER root
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN apt-get install -y inotify-tools sudo
ENV AF_DEFAULTGROUP=activefolder
ENV AF_ACTIVEUSER=active
ENV AF_DESCRIPTION=default
ENV AF_ROOT=/activearea
ENV AF_DIRECTORY=/activefolder
ENV AF_DOER=/activedoer
ENV AF_AUTOSTART=yes
RUN mkdir -p $AF_ROOT/.activefolder/doer
RUN mkdir -p $AF_ROOT/nutshell
RUN ln -s  $AF_ROOT/.activefolder/doer $AF_DOER
RUN ln -s  $AF_ROOT/nutshell $AF_DIRECTORY
VOLUME $AF_DIRECTORY
VOLUME $AF_DOER

ADD activefolder/init.d/ /etc/init.d/
ADD activefolder /usr/lib/activefolder
RUN mkdir /srv/activefolder
ADD start.sh /af-start.sh

RUN chmod 0755 /af-start.sh
ENTRYPOINT exec /af-start.sh
