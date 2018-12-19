MongoShardDir=/mongodb/mongodb111
FINAL=`echo ${MongoShardDir: -1}`
echo $FINAL
if [ $FINAL == "/" ]
    then
    	CUT=${MongoShardDir%/*}  	
else
	CUT=$MongoShardDir    	
fi
MongoShardDir=$CUT
echo $MongoShardDir