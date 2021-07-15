#!/bin/bash
apt update
apt install curl wget unzip -y
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

echo "Installing doctl"
wget https://github.com/digitalocean/doctl/releases/download/v1.60.0/doctl-1.60.0-linux-amd64.tar.gz
tar xf ./doctl-1.60.0-linux-amd64.tar.gz
mv ./doctl /usr/local/bin
doctl auth init --access-token $TOKEN_DIGITAL_OCEAN
doctl registry login

echo "doctl kubernetes cluster kubeconfig save e4613977-733f-4ba7-8aa6-69bc080ed41a"
doctl kubernetes cluster kubeconfig save e4613977-733f-4ba7-8aa6-69bc080ed41a

echo "Updating app"
kubectl apply -f ./deploy.yaml