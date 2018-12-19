#!/bin/bash
set -e
set -a

echo 'LOAD mongoShard.env'
source mongoShard.env

echo 'READ SHARD ENV'
ipListArr=(${IpList//,/ })
serverCount=0
extraHosts="\n"
configPrex="config"
shardPrex="shard"
FINAL=`echo ${MongoShardDir: -1}`
if [ $FINAL == "/" ]
    then
        CUT=${MongoShardDir%/*}     
else
    CUT=$MongoShardDir      
fi
MongoShardDir=$CUT

echo '-----GENERATE CONFIG FILES-----'
echo '-----1 GENERATE DOCKER COMPOSE-----'
echo '-----1.1 REPLACE PARAMETER-----'
for ((i=0;i<${#ipListArr[@]};i++));
do
    # 给每个机器生成对应的docker compose
    serverNo=$i
    ip=${ipListArr[$i]}
    cmd=$(printf 'mkdir -p ./%s/' $ip)
    `$cmd`
    # config server
    oldFilename='./templates/config.template.yml'
    newFilename=$(printf './%s/config.yml' $ip)
    envsubst < $oldFilename > $newFilename
    # shard
    oldFilename='./templates/shard.template.yml'
    newFilename=$(printf './%s/shard.yml' $ip)
    envsubst < $oldFilename > $newFilename
    # router
    oldFilename='./templates/router.template.yml'
    newFilename=$(printf './%s/router.yml' $ip)
    envsubst < $oldFilename > $newFilename   
done

echo '-----1.2 ADD EXTRA HOST-----'
for ((i=0;i<${#ipListArr[@]};i++));
do
    serverNo=$i
	ip=${ipListArr[$i]}
	extraHosts+="      - "
	extraHosts+="${configPrex}${serverNo}:${ip}\n"
	extraHosts+="      - "
	extraHosts+="${shardPrex}${serverNo}:${ip}\n"
done	
for ((i=0;i<${#ipListArr[@]};i++));
do
    ip=${ipListArr[$i]}
    printf "$extraHosts" >> ./${ip}/config.yml
    printf "$extraHosts" >> ./${ip}/shard.yml
    printf "$extraHosts" >> ./${ip}/router.yml
done    

echo '-----1.3 MERGE INTO ONE DOCKER COMPOSE-----'
for ((i=0;i<${#ipListArr[@]};i++));
do
    ip=${ipListArr[$i]}
    cat ./templates/head.template.yml ./${ip}/config.yml ./${ip}/shard.yml ./${ip}/router.yml > ./${ip}/docker-compose.yml    
    serverCount=$[$serverCount+1]; 
done 
serverCount=$[$serverCount-1]

echo '-----2 GENERATE INIT SCRIPT-----'
echo '-----2.1 GENERATE INIT ROUTER SCRIPT-----'
for ((i=0;i<${#ipListArr[@]};i++));
do
    serverNo=$i
    ip=${ipListArr[$i]}
    # init-router
    printf "sh.addShard(\"shard${serverNo}/shard${serverNo}:27019\")\n" >> ./${ipListArr[$serverCount]}/init-router.js
done 
    
echo '-----2.2 GENERATE INIT SHARD SCRIPT-----'
for ((i=0;i<${#ipListArr[@]};i++));
do
    serverNo=$i
    ip=${ipListArr[$i]}
    # init-shard
    printf "rs.initiate(\n" >> ./${ip}/init-shard.js
    printf "   {\n" >> ./${ip}/init-shard.js
    printf "      _id: \"shard${serverNo}\",\n" >> ./${ip}/init-shard.js
    printf "      members: [\n" >> ./${ip}/init-shard.js
    printf "         { _id: ${i}, host : \"shard${i}:27019\" },\n" >> ./${ip}/init-shard.js 
    printf "      ]\n" >> ./${ip}/init-shard.js 
    printf "   }\n" >> ./${ip}/init-shard.js 
    printf ")\n" >> ./${ip}/init-shard.js        
done 


echo '-----2.3 GENERATE INIT CONFIG SERVER SCRIPT-----'
serverNo=$i
ip=${ipListArr[$i]}
# init-configserver
printf "rs.initiate(\n" >> ./${ipListArr[$serverCount]}/init-configserver.js
printf "   {\n" >> ./${ipListArr[$serverCount]}/init-configserver.js
printf "      _id: \"configserver\",\n" >> ./${ipListArr[$serverCount]}/init-configserver.js
printf "      configsvr: true,\n" >> ./${ipListArr[$serverCount]}/init-configserver.js
printf "      members: [\n" >> ./${ipListArr[$serverCount]}/init-configserver.js
for ((j=0;j<${#ipListArr[@]};j++));
do
    printf "         { _id: ${j}, host : \"config${j}:27018\" },\n" >> ./${ipListArr[$serverCount]}/init-configserver.js
done  
printf "      ]\n" >> ./${ipListArr[$serverCount]}/init-configserver.js 
printf "   }\n" >> ./${ipListArr[$serverCount]}/init-configserver.js 
printf ")\n" >> ./${ipListArr[$serverCount]}/init-configserver.js        

echo '-----2.4 GENERATE INIT DATABASE SCRIPT-----'
cp ./templates/init-database.template.js ./${ipListArr[$serverCount]}/init-database.js

echo '-----3 GENERATE INIT SHELL-----'
for ((i=0;i<${#ipListArr[@]};i++));
do
    serverNo=$i
    ip=${ipListArr[$i]}
    if [ $i -ne $serverCount ]
    then
        oldFilename='./templates/init-shell-1.template.sh'
        newFilename=$(printf './%s/init-shell.sh' $ip)
        envsubst < $oldFilename > $newFilename  
    else
        oldFilename='./templates/init-shell-2.template.sh'
        newFilename=$(printf './%s/init-shell.sh' $ip)
        envsubst < $oldFilename > $newFilename          
    fi
done     



