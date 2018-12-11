sh.enableSharding("viid")
sleep(5*1000)
db.createCollection("viid.imageInfo")
sleep(5*1000)
sh.shardCollection("viid.imageInfo", { jpaShotTime: 1, jpaDeviceID: 1 })
sleep(5*1000)
db.createCollection("viid.face")
sleep(5*1000)
sh.shardCollection("viid.face", { jpaShotTime: 1, jpaDeviceID: 1 })
sleep(5*1000)
db.createCollection("viid.motorVehicle")
sleep(5*1000)
sh.shardCollection("viid.motorVehicle", { jpaShotTime: 1, jpaDeviceID: 1 })
db.printShardingStatus()

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}