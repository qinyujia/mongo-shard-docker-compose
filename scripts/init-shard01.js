rs.initiate(
   {
      _id: "shard01",
      members: [
         { _id: 0, host : "shard01:27019" },
      ]
   }
)
