rs.initiate(
   {
      _id: "configserver",
      configsvr: true,
      members: [
         { _id: "${serverNo}", host : "config${serverNo}:27018" },
      ]
   }
)