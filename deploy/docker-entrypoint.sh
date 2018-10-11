#!/bin/sh

set -xe

export PATH="$PATH:./bin"

bundle exec rake db:create
bundle exec rake db:migrate

bundle exec rake assets:precompile
bundle exec rake assets:clean

rm -f tmp/pids/server.pid
rails server -b 0.0.0.0 -p 3000
