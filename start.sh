#!/bin/sh
CUR_DIR=$(cd "$(dirname $0)"; pwd)

mkdir -p /var/log

sed -Ei "s/DEVICE_NAME/railway-$(date +%Y%m%d%H%M)/g" /etc/supervisor.d/cli.ini

if [ -x /usr/bin/nezha-agent ] && [ -f /etc/nezha-agent/config.yml ] && [ -n "$NZ_SERVER" ] && [ -n "$NZ_CLIENT_SECRET" ]; then
	NZ_UUID=$(uuidgen)
	NZ_TLS=${NZ_TLS:-false}
	sed -Ei "s/server: .*/server: $NZ_SERVER/g" /etc/nezha-agent/config.yml
	sed -Ei "s/client_secret: .*/client_secret: $NZ_CLIENT_SECRET/g" /etc/nezha-agent/config.yml
	sed -Ei "s/tls: .*/tls: $NZ_TLS/g" /etc/nezha-agent/config.yml
	sed -Ei "s/uuid: .*/uuid: $NZ_UUID/g" /etc/nezha-agent/config.yml
else
	rm -rf /etc/supervisor.d/nezha.ini
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf -n
