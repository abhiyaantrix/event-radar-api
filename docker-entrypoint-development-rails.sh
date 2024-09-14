#!/usr/bin/env sh

set -e

echo "Deleting pid file if exists"
if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
  echo "Server pid file deleted"
fi

exec "$@"
