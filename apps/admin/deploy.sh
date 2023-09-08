#!/bin/bash
export PATH="$PATH:/home/ubuntu/.nvm/versions/node/v20.6.0/bin"

cd /home/ubuntu/sold-store-2
git pull origin main
yarn install
yarn build
pm2 stop admin
pm2 start npm --name "admin" -- run "start:admin"
