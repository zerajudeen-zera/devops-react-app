#!/bin/bash

echo "Started deployment process to the AMAZON EC2 server....."

# Setting required environment variables
AMAZON_EC2_USER = "ubuntu"
AMAZON_EC2_IP = "172.31.3.49"
COMPOSE_FILE = "docker-compose.yml"
KEY_PATH = "/home/ubuntu/key.pem"

#securely copy the compose file from source server to the App server

echo "copying the compose file from jenkins ec2 to app ec2"
scp -i "$KEY_PATH" "$COMPOSE_FILE $AMAZON_EC2_USER@$AMAZON_EC2_IP:/home/$AMAZON_EC2_USER"

#deploy the application on to the server by ssh into the server

echo "Deploying to amazon app ec2"

ssh -i "$KEY_PATH" "$AMAZON_EC2_USER@$AMAZON_EC2_IP" \
"cd /home/$AMAZON_EC2_USER && \
echo 'Stopping if any container is up and running' && \
docker compose down && \
echo 'pulling the latest prod image from docker hub' && \
docker compose pull && \
echo 'Deploying the application to the server' && \
docker compose up -d && \
echo 'Deployment completed !'"





