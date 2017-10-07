#!/bin/bash
userid="user1 user2";
timer=5
isCreatNameSpace=true
if $isCreatNameSpace
then
  for user in $userid; do
	  kubectl create -f ./namespaces/$user.yaml
  done	
fi

numberOfJobs=100
#FULL_COMMAND="kubectl --namespace=\"user1\" create -f ./jobs/vgg-gpu-job.yaml"

job="vgg16"
jobName="$job-gpu-job"

for i in `seq 1 $numberOfJobs`;
do  
    # create new jobs
    echo "apiVersion: v1
kind: Pod
metadata:
  name: tensorflow-$job-gpu$i
spec:
  containers:
  - name: tensorflow-$job-gpu
    image: swiftdiaries/bench
    command:
    - \"/bin/bash\"
    - \"-c\"
    - \"python tf_cnn_benchmarks.py --device=gpu --model=$job --batch_size=32 --num_gpus=1\"  
    resources:
      requests:
        alpha.kubernetes.io/nvidia-gpu: 1
        cpu: 24
      limits:
        alpha.kubernetes.io/nvidia-gpu: 1
        cpu: 24
    volumeMounts:
    - name: nvidia-driver-375-82
      mountPath: /usr/local/nvidia
      readOnly: true
    - name: libcuda-so
      mountPath: /usr/lib/x86_64-linux-gnu/libcuda.so
    - name: libcuda-so-1
      mountPath: /usr/lib/x86_64-linux-gnu/libcuda.so.1
    - name: libcuda-so-375-82
      mountPath: /usr/lib/x86_64-linux-gnu/libcuda.so.375.82
      readOnly: true
  restartPolicy: Never
  volumes:
  - name: nvidia-driver-375-82
    hostPath:
      path: /usr/lib/nvidia-375
  - name: libcuda-so
    hostPath:
      path: /usr/lib/x86_64-linux-gnu/libcuda.so
  - name: libcuda-so-1
    hostPath:
      path: /usr/lib/x86_64-linux-gnu/libcuda.so.1
  - name: libcuda-so-375-82
    hostPath:
      path: /usr/lib/x86_64-linux-gnu/libcuda.so.375.82
    " > ./jobs/$jobName$i.yaml
    
    FULL_COMMAND="kubectl create -f ./jobs/$jobName$i.yaml"        
    >&2 echo "Starting job $i."
	  (TIMEFORMAT='%R'; time $FULL_COMMAND 2>application$i.log) 2> $i.time &
done
wait

START=$(date +%s)
initTime=20
sleep $initTime
./killPods.sh

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds" 
