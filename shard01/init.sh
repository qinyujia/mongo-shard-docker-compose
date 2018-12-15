#!/bin/bash
#echo "--------init config server--------"
#docker exec mongos_config01_1 sh -c "mongo --port 27018 < /scripts/init-configserver.js"
echo "--------init shard--------"
docker exec mongos_shard01_1 sh -c "mongo --port 27019 < /scripts/init-shard01.js"
#sleep 5
#echo "--------init router--------"
#docker exec mongos_router01_1 sh -c "mongo --port 27017 < /scripts/init-router.js"