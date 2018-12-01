#!/bin/bash

docker exec mongos_config01_1 sh -c "mongo --port 27018 < /scripts/init-configserver.js"
docker exec mongos_shard01_1 sh -c "mongo --port 27019 < /scripts/init-shard01.js"
sleep 20
docker exec mongos_router01_1 sh -c "mongo --port 27017 < /scripts/init-router.js"