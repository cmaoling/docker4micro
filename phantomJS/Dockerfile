FROM armhfbuild/debian:wheezy
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"

# based on http://phantomjs.org/build.html

ENV DEBIAN_FRONTEND noninteractive
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN apt-get install -y build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev
RUN apt-get install -y git  
VOLUME /phantomjs
RUN git clone git://github.com/ariya/phantomjs.git
WORKDIR /phantomjs
RUN git checkout 2.0
