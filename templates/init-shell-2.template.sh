#!/bin/bash

echo "--------init config server--------"
docker exec mongos_config${serverNo}_1 sh -c "mongo --port 27018 < init-configserver.js"
echo "--------init shard--------"
docker exec mongos_shard${serverNo}_1 sh -c "mongo --port 27019 < init-shard${serverNo}.js"
sleep 20
echo "--------init router--------"
docker exec mongos_router${serverNo}_1 sh -c "mongo --port 27017 < init-router.js"
sleep 10
echo "--------init database--------"
docker exec mongos_router${serverNo}_1 sh -c "mongo --port 27017 < init-database.js"