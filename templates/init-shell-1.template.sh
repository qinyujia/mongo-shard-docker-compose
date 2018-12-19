#!/bin/bash

echo "--------init shard--------"
docker exec mongos_shard${serverNo}_1 sh -c "mongo --port 27019 < init-shard.js"