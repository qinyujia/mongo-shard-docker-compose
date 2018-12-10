sh.enableSharding("viid")
db.createCollection("viid.imageInfo")
sh.shardCollection("viid.imageInfo", { jpaShotTime: 1, jpaDeviceID: 1 })