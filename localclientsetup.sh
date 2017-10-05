#!/bin/bash
#usage: ./localclientsetup.sh [username] [masterIPaddress] [keyfilelocation]
echo "./localclientsetup.sh [username] [masterIPaddress] [keyfilelocation]"
if [ -z "$1" ]
then
	username="cc"
else
	username="$1"
fi
if [ -z "$2" ]
then
	hostIP="129.114.108.146"
else
	hostIP="$2"
fi
if [ -z "$3" ]
then
	keyfile="~/Dropbox/Research/chameleoncloud/chameleon.pem"
else
	keyfile="$3"
fi
ssh-keygen -R $hostIP
sudo bash -c "apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update"
sudo apt-get install -y kubectl
#brew install kubectl
#mkdir -p  ~/.kube/admin.conf
#echo "ssh -i $keyfile $username@$hostIP \"echo hello $hostIP\""
ssh -i $keyfile $username@$hostIP "echo hello $hostIP"
scp -i $keyfile $username@$hostIP:~/config/admin.conf ~/.kube/admin.conf
export KUBECONFIG=~/.kube/admin.conf
kubectl create -f https://git.io/kube-dashboard
echo "######################### Dashboard is now installed, you can run \$kubectl proxy to view the Dashboard ##########################################"
#sudo systemctl daemon-reload
#sudo systemctl restart kubelet
# if it does not work, try export KUBECONFIG=~/.kube/admin.conf; Check $kubectl version

