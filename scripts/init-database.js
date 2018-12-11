print("----start sharding viid---");
use viid
sh.enableSharding("viid")
sleep(5*1000)

print("----start createCollection imageInfo---");
db.createCollection("imageInfo")
sleep(5*1000)
print(("----start shardCollection imageInfo---");
db.imageInfo.createIndex( { jpaShotTime: 1, jpaDeviceID: 1 } )
sh.shardCollection("viid.imageInfo", { jpaShotTime: 1, jpaDeviceID: 1 })
sleep(5*1000)

print("----start createCollection face---");
db.createCollection("face")
sleep(5*1000)
print("----start shardCollection face---");
db.face.createIndex( { jpaShotTime: 1, jpaDeviceID: 1 } )
sh.shardCollection("viid.face", { jpaShotTime: 1, jpaDeviceID: 1 })
sleep(5*1000)

print("----start createCollection motorVehicle---");
db.createCollection("motorVehicle")
sleep(5*1000)
print("----start shardCollection motorVehicle---");
db.motorVehicle.createIndex( { jpaShotTime: 1, jpaDeviceID: 1 } )
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