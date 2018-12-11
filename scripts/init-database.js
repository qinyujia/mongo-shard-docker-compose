print("----start sharding viid---");
use viid
sh.enableSharding("viid")
sleep(5*1000)

print("----start createCollections---");
use viid
db.createCollection("imageInfo")
db.imageInfo.createIndex( { jpaShotTime: 1, jpaDeviceID: 1 } )
db.createCollection("face")
db.face.createIndex( { jpaShotTime: 1, jpaDeviceID: 1 } )
db.createCollection("motorVehicle")
db.motorVehicle.createIndex( { jpaShotTime: 1, jpaDeviceID: 1 } )

sleep(5*1000)
print("----start shardCollections---");
sh.shardCollection("viid.imageInfo", { jpaShotTime: 1, jpaDeviceID: 1 })
sh.shardCollection("viid.face", { jpaShotTime: 1, jpaDeviceID: 1 })
sh.shardCollection("viid.motorVehicle", { jpaShotTime: 1, jpaDeviceID: 1 })

print("----print sharding info---");
db.printShardingStatus()

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}