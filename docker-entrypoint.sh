#!/bin/sh
set -e
[ -n "$TZ" ] && [ -f /usr/share/zoneinfo/"$TZ" ] && { cp /usr/share/zoneinfo/"$TZ" /etc/localtime; echo "$TZ" > /etc/timezone; }
exec "$@"
