############################################################
# Dockerfile to build a webdav link within a docker container
# container has to be called w/ --privilege option to enable mount
# provide as WEBDAV the server to connect to
# link target volume with /webdav volume in container
# secrets may be shared from host by providing a "secret" file in the target mounting directory
# sample call: "docker run --privilege -t <image> -v /webdav:/mediacenter/1und1 -e WEBDAV=https://mediacenter.gmx.net="
# sample secret file: <your server ID> <your password on WEBDAV server>
# t-online: https://webdav.mediencenter.t-online.de 
# GMX: https://mediacenter.gmx.net
# 1und1: https://webdav.office.1und1.de
#
# Based on armhf-debian
FROM armhfbuild/debian:wheezy

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ####################### example call: docker run --privilege -t colinas/webdav
RUN apt-get update
ENV DEBIAN_FRONTEND "noninteractive"
RUN apt-get -y install davfs2
ENV WEBDAV=https://default.nil
VOLUME /webdav
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
ENTRYPOINT exec /start.sh
