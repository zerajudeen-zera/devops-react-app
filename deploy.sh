# #!/bin/bash

# echo "Started deployment process to the AMAZON EC2 server....."

# # Setting required environment variables
# AMAZON_EC2_USER = "ubuntu"
# AMAZON_EC2_IP = "172.31.3.49"
# COMPOSE_FILE = "docker-compose.yml"
# KEY_PATH = "/home/ubuntu/key.pem"

# #securely copy the compose file from source server to the App server

# echo "copying the compose file from jenkins ec2 to app ec2"
# scp -i "$KEY_PATH" "$COMPOSE_FILE $AMAZON_EC2_USER@$AMAZON_EC2_IP:/home/$AMAZON_EC2_USER"

# #deploy the application on to the server by ssh into the server

# echo "Deploying to amazon app ec2"

# ssh -i "$KEY_PATH" "$AMAZON_EC2_USER@$AMAZON_EC2_IP" \
# "cd /home/$AMAZON_EC2_USER && \
# echo 'Stopping if any container is up and running' && \
# docker-compose down && \
# echo 'pulling the latest prod image from docker hub' && \
# docker-compose pull && \
# echo 'Deploying the application to the server' && \
# docker-compose up -d && \
# echo 'Deployment completed !'"


#!/bin/bash

set -e  # Exit on any error

echo "🚀 Starting deployment process to the Amazon EC2 server...."

# Validate required environment variables
: "${AMAZON_EC2_USER:?Environment variable AMAZON_EC2_USER not set}"
: "${AMAZON_EC2_IP:?Environment variable AMAZON_EC2_IP not set}"
: "${KEY_PATH:?Environment variable KEY_PATH not set}"
: "${COMPOSE_FILE:?Environment variable COMPOSE_FILE not set}"

echo "Adding EC2 host key to known_hosts...."
ssh-keyscan -H "$AMAZON_EC2_IP" >> ~/.ssh/known_hosts

echo "📦 Copying the compose file from Jenkins to EC2..."
scp -i "$KEY_PATH" "$COMPOSE_FILE" "$AMAZON_EC2_USER@$AMAZON_EC2_IP:/home/$AMAZON_EC2_USER/"

echo "🔧 Deploying on EC2..."
ssh -i "$KEY_PATH" "$AMAZON_EC2_USER@$AMAZON_EC2_IP" "docker-compose -f /home/$AMAZON_EC2_USER/$COMPOSE_FILE up -d"

echo "✅ Deployment complete!"






