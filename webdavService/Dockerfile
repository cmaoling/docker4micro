# example call: docker run --privilege -t colinas/webdav
RUN apt-get update
RUN apt-get -y install apt-get  install davfs2
ENV WEBDAV=https://webdav.office.1und1.de
VOLUME /webdav
RUN touch /webdav/secret
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
ENTRYPOINT exec /start.sh
