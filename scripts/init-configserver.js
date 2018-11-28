rs.initiate(
   {
      _id: "configserver",
      configsvr: true,
      version: 1,
      members: [
         { _id: 0, host : "config01:37019" },
         { _id: 1, host : "config02:37019" }
      ]
   }
)