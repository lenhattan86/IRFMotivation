#!/bin/bash
userid="user1 user2";
initTime=1

isCreatNameSpace=true
if $isCreatNameSpace
then
  for user in $userid; do
	  kubectl create -f ./namespaces/$user.yaml
  done	
fi

mkdir logs
mkdir time

## manual playing jobs

user1_num=1
user1="user1"
for i in `seq 1 $user1_num`;
do  
	./job.sh $user1 $user1-$i alexnet 2 1 1 &
done
user2_num=1
user2="user2"
for i in `seq 1 $user2_num`;
do  
	./job.sh $user2 $user2-$i s-linear 2 1 3 &
done

START=$(date +%s)
initTime=20
sleep $initTime
./killPods.sh

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"