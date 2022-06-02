#!/bin/sh
/usr/bin/pulseaudio -D --exit-idle-time=-1
exec "$@"
