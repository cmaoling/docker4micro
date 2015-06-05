############################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM armhfbuild/debian:wheezy

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Install APACHE2 on micro best of my knowledge
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
#Sqlite packages installation:
RUN apt-get install -y sqlite3

#Apache2 webserver packages installation:
RUN apt-get install -y apache2 libapache2-mod-php5 nano

#Php5 packages installation:
RUN ["/bin/bash","-c","apt-get install -y php5-gd php5-json php5-sqlite php5-curl php5-intl php5-mcrypt php5-imagick php-net-ftp php5-gmp php-apc php5-apcu php5-imagick"]
RUN ["/usr/bin/openssl","genrsa", "-out /etc/ssl/private/apache.key", "2048"]
RUN ["/usr/bin/openssl","req", "-new", "-x509", "-key /etc/ssl/private/apache.key", "-days 365", "-sha256", "-out /etc/ssl/certs/apache.crt"]
RUN ["/usr/sbin/a2enmod","ssl"]
RUN ["/usr/sbin/a2enmod","rewrite"]
RUN ["/usr/sbin/a2ensite","default-ssl.conf"]
RUN ["/usr/sbin/update-rc.d apache2 enable"]


EXPOSE 80
EXPOSE 443

##################### INSTALLATION END #####################
