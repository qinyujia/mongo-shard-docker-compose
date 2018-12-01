#!/bin/bash

docker exec mongos_config02_1 sh -c "mongo --port 27018 < /scripts/init-configserver.js"
docker exec mongos_shard02_1 sh -c "mongo --port 27019 < /scripts/init-shard02.js"
sleep 20
docker exec mongos_router02_1 sh -c "mongo --port 27017 < /scripts/init-router.js"