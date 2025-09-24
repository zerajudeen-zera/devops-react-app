#!/bin/bash

echo "Building Docker image..."
docker build -t react-ecom-app:latest .

echo "Build completed"
