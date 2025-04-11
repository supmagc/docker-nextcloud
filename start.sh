#!/bin/sh

mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord \

/usr/bin/supervisord -c /supervisord.conf
