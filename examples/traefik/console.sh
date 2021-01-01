#!/bin/sh
docker-compose exec -e RAILS_ENV=production imgshr rails c
