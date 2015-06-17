#!/bin/bash

# Start pagemaster
/etc/init.d/samba start
/etc/init.d/activefolder start
netstat -tulpn | egrep "samba|smbd|nmbd|winbind"
tail -f /srv/activefolder/*
