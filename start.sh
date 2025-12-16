#!/bin/sh

mkdir -p /var/log

sed -Ei "s/DEVICE_NAME/railway-$(date +%Y%m%d%H%M)/g" /etc/supervisor.d/cli.ini

[ -z "$NZ_SERVER" ] || [ -z "$NZ_CLIENT_SECRET" ] || {
	curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh && chmod +x agent.sh && env NZ_SERVER=$NZ_SERVER NZ_TLS=false NZ_CLIENT_SECRET=$NZ_CLIENT_SECRET ./agent.sh
}

exec /usr/bin/supervisord -c /etc/supervisord.conf -n
