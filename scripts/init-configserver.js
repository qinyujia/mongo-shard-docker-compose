rs.initiate(
   {
      _id: "configserver",
      configsvr: true,
      members: [
         { _id: 0, host : "config01:27018" },
         { _id: 1, host : "config02:27018" }
      ]
   }
)