echo "--------shard database--------"
sh.enableSharding("viid")
echo "--------create collection--------"
db.createCollection("viid.imageInfo")
echo "--------shard collection--------"
sh.shardCollection("viid.imageInfo", { jpaShotTime: 1, jpaDeviceID: 1 })