#!/bin/bash

echo "--------init config server--------"
docker exec mongos_config${serverNo}_1 sh -c "mongo --port 27018 < /scripts/init-configserver.js"
echo "--------init shard--------"
docker exec mongos_shard${serverNo}_1 sh -c "mongo --port 27019 < /scripts/init-shard.js"
sleep 20
echo "--------init router--------"
docker exec mongos_router${serverNo}_1 sh -c "mongo --port 27017 < /scripts/init-router.js"
sleep 10
echo "--------init database--------"
docker exec mongos_router${serverNo}_1 sh -c "mongo --port 27017 < /scripts/init-database.js"