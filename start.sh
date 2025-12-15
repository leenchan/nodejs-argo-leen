#!/bin/sh

# 確保 log 目錄存在
mkdir -p /var/log

sed -Ei "s/DEVICE_NAME/railway-$(date +%Y%m%d%H%M)/g" /etc/supervisor.d/cli.ini

# 啟動 supervisord
node ws.js
exec /usr/bin/supervisord -c /etc/supervisord.conf -n
