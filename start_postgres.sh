#!/bin/bash

# file from: https://github.com/docker-library/postgres/blob/master/9.3/docker-entrypoint.sh

set -e

if [ "$1" = 'postgres' ]; then
	chown -R postgres "$PGDATA"

	if [ -z "$(ls -A "$PGDATA")" ]; then
		gosu postgres initdb

		# sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf


		{ echo; echo 'host all all 0.0.0.0/0 trust'; } >> "$PGDATA"/pg_hba.conf

		{ echo; echo "listen_addresses = '*'"; } >> "$PGDATA"/postgresql.conf
	fi

	exec gosu postgres "$@"
fi

exec "$@"
