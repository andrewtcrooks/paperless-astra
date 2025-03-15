#!/bin/bash

# Exit on error
set -e

# Get the version from the environment or use latest as default
VERSION=${VERSION:-latest}

# Docker image name
IMAGE_NAME="paperlessastra/paperless-astra"

echo "Building Docker image ${IMAGE_NAME}:${VERSION}..."

# Build the image
docker build -t ${IMAGE_NAME}:${VERSION} .

# Tag as latest if not already latest
if [ "$VERSION" != "latest" ]; then
    echo "Tagging as latest..."
    docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest
fi

echo "Pushing Docker image ${IMAGE_NAME}:${VERSION}..."

# Push the version tag
docker push ${IMAGE_NAME}:${VERSION}

# Push latest tag if not already latest
if [ "$VERSION" != "latest" ]; then
    echo "Pushing latest tag..."
    docker push ${IMAGE_NAME}:latest
fi

echo "Successfully built and pushed ${IMAGE_NAME}:${VERSION}"