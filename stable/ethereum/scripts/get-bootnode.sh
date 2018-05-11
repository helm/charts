apk add --no-cache curl; 
CNT=0;
echo "retreiving bootnodes from $BOOTNODE_SVC"
while [ $CNT -le 90 ] 
do
  curl -m 5 -s $BOOTNODE_SVC | xargs echo -n >> /geth/bootnodes;
  if [ -s /geth/bootnodes ] 
  then
    cat /geth/bootnodes;
    exit 0;
  fi;

  echo "no bootnodes found. retrying $CNT..."; 
  sleep 2 || break;
  CNT=$((CNT+1));
done;
echo "WARNING. unable to find bootnodes. continuing but geth may not be able to find any peers.";
exit 0;