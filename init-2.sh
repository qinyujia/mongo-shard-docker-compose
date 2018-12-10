#!/bin/bash
echo "--------init config server--------"
docker exec mongos_config02_1 sh -c "mongo --port 27018 < /scripts/init-configserver.js"
echo "--------init shard--------"
docker exec mongos_shard02_1 sh -c "mongo --port 27019 < /scripts/init-shard02.js"
sleep 20
echo "--------init router--------"
docker exec mongos_router02_1 sh -c "mongo --port 27017 < /scripts/init-router.js"