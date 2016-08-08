#!/bin/bash

echo "Building Base Image"
docker build -t live_sound .

echo "Starting Postgresql"
docker run -d --name postgres_live_sound postgres

sleep 5

echo "create/migrate db"
docker run --name live_sound_temp --link postgres_live_sound:db live_sound bundle exec rake db:create
docker commit live_sound_temp live_sound
docker rm live_sound_temp

echo "migrate db"
docker run --name live_sound_temp --link postgres_live_sound:db live_sound bundle exec rake db:migrate
docker commit live_sound_temp live_sound
docker rm live_sound_temp

echo "start live_sound"
docker run --rm --link postgres_live_sound:db live_sound bundle exec rspec spec
TEST_EXIT_CODE=$?

echo "shutdown postgres and delete"
docker stop postgres_live_sound
docker rm -f postgres_live_sound

exit $TEST_EXIT_CODE
