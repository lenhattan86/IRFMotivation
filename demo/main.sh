#!/bin/bash
userid="user1 user2";

isCreatNameSpace=true
if $isCreatNameSpace
then
  for user in $userid; do
	  kubectl create -f ./namespaces/$user.yaml
  done	
fi

mkdir logs

sleep $initTime
./killPods.sh