#!/bin/sh

set -xe

export PATH="$PATH:./bin"

bundle exec rake db:create
bundle exec rake db:migrate

rm -f tmp/pids/server.pid
rails server -b 0.0.0.0 -p 3000
