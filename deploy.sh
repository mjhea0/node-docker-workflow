#!/bin/bash

curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
git clone https://github.com/mjhea0/node-docker-workflow.git
cd node-docker-workflow
docker-compose build
docker-compose up -d