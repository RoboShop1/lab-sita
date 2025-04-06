#!/bin/bash
set -e

env=$1
cluster_name=$2
#new_cluster_version=$3
OLD_VERSION=$3

echo "Creating Kubeconfig file..."
aws eks update-kubeconfig --region ap-south-1 --name $env-$cluster_name --region us-east-1

echo "Waiting for 2 minutes before cordoning the worker nodes..."
sleep 120

NODES=`kubectl get nodes -o wide | grep $OLD_VERSION | awk '{ print $1 }'`
for NODE in $NODES; do
   echo "Cordoning... ${NODE}"
   kubectl cordon ${NODE}
done

echo "Waiting for 2 minutes before draining the worker nodes..."
sleep 120

for NODE in $NODES; do
   echo "Draining... ${NODE}"
   kubectl drain ${NODE} --delete-emptydir-data --ignore-daemonsets --force
done
