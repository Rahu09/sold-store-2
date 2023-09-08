#!/bin/bash
export PATH="$PATH:/home/ubuntu/.nvm/versions/node/v20.6.1/bin"

cd /home/ubuntu/sold-store-2
git pull origin main
yarn install
yarn build
pm2 stop server
pm2 start server
# pm2 start npm --name "server" -- run "start:server"
