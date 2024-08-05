#!/bin/bash

# Set variables
REGISTRY_HOST="10.0.10.251"
REGISTRY_PORT="5000"
IMAGE_NAME="kdjdk"
TAG="latest"

# Full registry address
REGISTRY_ADDRESS="${REGISTRY_HOST}:${REGISTRY_PORT}"

# Function to add insecure registry to Docker config
configure_insecure_registry() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "Configuring Docker for macOS..."
        CONFIG_FILE="$HOME/Library/Group Containers/group.com.docker/settings.json"
        if [ -f "$CONFIG_FILE" ]; then
            jq --arg reg "$REGISTRY_ADDRESS" '.["insecure-registries"] += [$reg]' "$CONFIG_FILE" > temp.json && mv temp.json "$CONFIG_FILE"
            echo "Added insecure registry to Docker config. Please restart Docker Desktop."
        else
            echo "Docker config file not found. Please add insecure registry manually in Docker Desktop preferences."
        fi
    else
        # Linux
        echo "Configuring Docker for Linux..."
        sudo mkdir -p /etc/docker
        echo "{\"insecure-registries\":[\"$REGISTRY_ADDRESS\"]}" | sudo tee /etc/docker/daemon.json > /dev/null
        sudo systemctl restart docker
    fi
}

# Main script
echo "Configuring insecure registry..."
configure_insecure_registry

echo "Tagging image..."
docker tag $IMAGE_NAME $REGISTRY_ADDRESS/$IMAGE_NAME:$TAG

echo "Pushing image to registry..."
docker push $REGISTRY_ADDRESS/$IMAGE_NAME:$TAG

echo "Script completed. Image should be pushed to $REGISTRY_ADDRESS/$IMAGE_NAME:$TAG"