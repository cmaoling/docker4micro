#!/bin/bash

# Start activefolder
/etc/init.d/activefolder start
tail -f /srv/activefolder/*
