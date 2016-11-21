#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- disque-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'disque-server' -a "$(id -u)" = '0' ]; then
	chown -R disque .
	exec su-exec disque "$0" "$@"
fi

exec "$@"