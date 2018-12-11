echo "--------init database--------"
docker exec mongos_router02_1 sh -c "mongo --port 27017 < /scripts/init-database.js"