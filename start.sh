#!/bin/bash

# Delete any of the running containers
docker rm -f $(docker ps -qa)
# Create Network
docker network create trio-network
# Build Images
# Build the flask app Image // application container
docker build -t trio-task-flask:latest flask-app
docker build -t trio-task-db:latest db

#Run mysql container
docker run -d --network trio-network --name mysql trio-task-db:latest

# Run the flask app container in the network
docker run -d --network trio-network --name flask-app trio-task-flask:latest
# Run NGNIX  container in the network
docker run -d --network trio-network --name nginx --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf -p 80:80 --name nginx nginx:alpine
