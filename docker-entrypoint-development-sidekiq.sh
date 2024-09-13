#!/usr/bin/env sh

set -e

echo "Checking gem dependencies"
bundle check \
  || (
    echo "Installing missing gems" \
      && bundle install --jobs $(expr $(nproc) - 1) --retry 3
  )

echo "Run migrations or create DBs with seeds"
(rails db:exists && rails db:migrate) || rails db:setup db:test:prepare

mkdir -p tmp/cache tmp/pids tmp/sessions tmp/sockets

exec "$@"
