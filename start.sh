#!/bin/sh
CUR_DIR=$(cd "$(dirname $0)"; pwd)

mkdir -p /var/log

sed -Ei "s/DEVICE_NAME/railway-$(date +%Y%m%d%H%M)/g" /etc/supervisor.d/cli.ini

[ -z "$NZ_SERVER" ] || [ -z "$NZ_CLIENT_SECRET" ] || {
	curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh && chmod +x agent.sh && env NZ_SERVER=$NZ_SERVER NZ_TLS=${NZ_TLS:-true} NZ_CLIENT_SECRET=$NZ_CLIENT_SECRET ./agent.sh || true
	[ -x /opt/nezha/agent/nezha-agent ] && {
		cp /opt/nezha/agent/nezha-agent $CUR_DIR/npm
		rm -rf /opt/nezha
		cat <<-EOF >$CUR_DIR/config.yml
		client_secret: ${NZ_CLIENT_SECRET}
		debug: false
		disable_auto_update: true
		disable_command_execute: false
		disable_force_update: true
		disable_nat: false
		disable_send_query: false
		gpu: false
		insecure_tls: true
		ip_report_period: 1800
		report_delay: 4
		server: ${NZ_SERVER}
		skip_connection_count: true
		skip_procs_count: true
		temperature: false
		tls: ${NZ_TLS}
		use_gitee_to_upgrade: false
		use_ipv6_country_code: false
		uuid: ${UUID}
		EOF
		nohup $CUR_DIR/npm -c $CUR_DIR/config.yml >/dev/null 2>&1 &
	}
}

exec /usr/bin/supervisord -c /etc/supervisord.conf -n
