#!/bin/bash -e

cd /home/ubuntu/deploy/nextepc/webui
sudo apt-get -y install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get -y install nodejs
npm install
npm run dev &
