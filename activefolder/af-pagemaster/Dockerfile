############################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM colinas/activefolder

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Create pagemaster container on micro best of my knowledge
ENV DEBIAN_FRONTEND "noninteractive"
ENV AF_DEFAULTGROUP pagemaster

ADD doer/ /activedoer/
