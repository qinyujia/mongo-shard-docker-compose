rs.initiate(
   {
      _id: "shard${serverNo}",
      members: [
         { _id: 0, host : "shard${serverNo}:27019" },
      ]
   }
)