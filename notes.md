to connect to aws ssh terminal -
$ ssh -i todo-class.pem ubuntu@ec2-3-86-84-63.compute-1.amazonaws.com

to check the read and write permission(if there are too many aws may refues to connect) -
$ ls -ltr todo-class.pem
-rw-r--r-- 1 RAHUL 197121 1678 Aug 6 19:25 todo-class.pem

to change the permission to just you (revoke other user permission ) -
$ chmod 600 todo-class.pem

checking again -
$ ls -ltr todo-class.pem
-rw------- 1 RAHUL 197121 1678 Aug 6 19:25 todo-class.pem

clone your repo here -
$ git clone <Your Repo>

install nvm (to install node and run npm command) -
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

ran last three command from the that recommended -

then installed node -
$ nvm install node

installed modules -
$ npm i

to continiously run the backend server we need process manager like pm2 -
$ npm i -g pm2
$ pm2 start filename.js
$ pm2 list
$ pm2 kill

command to exit the aws machine -
$ exit

```# adding CI/CD #~~~~~~~~~~~~

now if change comes we need to type so many command (from top till now so we will automate it using ci/cd).

so we will make a script to automate this process.

copying deploy.sh in part-2-scripts to aws machine home terminal which will do every thing we have done untill now inside aws machine.

We still have to run the command in script-local.sh in our own system after every git push, so we will automate this using github actions.

To add the github action we will make a directory .github/workflows which will contains all our github actions in .yaml format.

we only have one that is ci.yaml-

name: Deploy

on:
push:
branches: - master

jobs:
deploy:
runs-on: ubuntu-latest --//will create a ubuntu machine somewhere in cloud

    steps:
    - name: Checkout code
      uses: actions/checkout@v2     --//pre-built github action's command ( like npm libraries) which will clone the current repo in the machine.

    - name: SSH and deploy
      env:
        SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}   --// bring the env variable from github settings
      run: |
        echo "$SSH_PRIVATE_KEY" > keyfile     --copy ssh eeys to a file to use
        chmod 600 keyfile
        mkdir -p ~/.ssh                      --//so that known hosts error dosent occure
        cp known_hosts ~/.ssh/known_hosts    --//so that known hosts error dosent occure
        ssh -t -i keyfile ubuntu@ec2-44-204-241-26.compute-1.amazonaws.com "sudo bash ~/deploy.sh"  //ssh in aws and call deploy.sh

-name dont matter much in github actions file, they can be anything.

~~~~~~# setting up reverse proxy #~~~~~~~~~~~~

--command to make known hosts file - (run from same directory(folder) from which you are calling git push)
$ ssh-keyscan <ec2-url> >> known hosts

install nginx in your aws machine
$ sudo apt update
$ sudo apt-get install nginx

remove the nginx.conf file that is already there and make a new one and paste the material from nginx.conf in part-1-nginx folder.
( too hard to edit instead we will copy paste our own ).
$ sudo rm /etc/nginx/nginx.conf
$ sudo vi /etc/nginx/nginx.conf

and paste this -
events {
worker_connections 1024;
}

http {
server {
listen 80;
server_name todo-app-backend.100xdevs.com;

        location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }

}

now we will restart the nginx
$ sudo nginx -s reload

~~~~~~# getting certificate #~~~~~~~~~~~~

go to certbot website select your server and system( nginx and ubuntu 20)
and it will guide you how to setup certbot.

1. SSH into the server

2.Remove certbot-auto and any Certbot OS packages (not necessary for first time)

3.Install Certbot
$ sudo snap install --classic certbot

4.Prepare the Certbot command
$ sudo ln -s /snap/bin/certbot /usr/bin/certbot

5.Choose how you'd like to run Certbot
$ sudo certbot --nginx

6.
```
