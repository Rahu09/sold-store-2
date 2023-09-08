#!/bin/bash
export PATH=$PATH:/home/ubuntu/.nvm/versions/node/v20.5.1/bin

cd /home/ubuntu/sold-store-2
git pull origin main
yarn install
yarn build
pm2 stop client
pm2 start npm --name "client" -- run "start:client"
