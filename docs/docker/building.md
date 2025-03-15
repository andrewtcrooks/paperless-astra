# Building and Publishing Docker Images

This guide explains how to build and publish Docker images for Paperless-Astra.

## Prerequisites

Before you begin, make sure you have:

1. Docker installed and running on your system
2. A Docker Hub account
3. Logged in to Docker Hub using `docker login`

## Building the Image

You can build the Docker image in two ways:

### Using the Build Script

We provide a convenient script that handles building and pushing the image:

```bash
# Build and push latest version
./scripts/build-and-push.sh

# Build and push specific version
VERSION=1.0.0 ./scripts/build-and-push.sh
```

### Manual Build

If you prefer to build manually:

```bash
# Build the image
docker build -t paperlessastra/paperless-astra:latest .

# Optional: Tag with specific version
docker tag paperlessastra/paperless-astra:latest paperlessastra/paperless-astra:1.0.0
```

## Pushing to Docker Hub

After building, you can push the image to Docker Hub:

```bash
# Push latest version
docker push paperlessastra/paperless-astra:latest

# Push specific version
docker push paperlessastra/paperless-astra:1.0.0
```

## Using Pre-built Images

Our Docker Compose configurations are set up to use the official images from Docker Hub. You can pull them directly:

```bash
docker pull paperlessastra/paperless-astra:latest
```

## Image Tags

We maintain several tags for different use cases:

- `latest`: The most recent stable release
- `x.y.z` (e.g., `1.0.0`): Specific version releases
- `develop`: Latest development build (may be unstable)

## Building Custom Images

If you need to customize the image, you can modify the `Dockerfile` and build your own version:

1. Clone the repository
2. Modify the `Dockerfile` as needed
3. Build with a custom tag:
   ```bash
   docker build -t your-org/paperless-astra:custom .
   ```

## Troubleshooting

Common issues and solutions:

1. **Permission Denied**
   - Make sure you're logged in to Docker Hub
   - Verify you have the correct permissions for the repository

2. **Build Failures**
   - Check your Docker daemon is running
   - Ensure you have sufficient disk space
   - Verify all required build dependencies are available

3. **Push Failures**
   - Check your internet connection
   - Verify your Docker Hub credentials
   - Ensure the repository exists on Docker Hub

## Security Notes

- Always verify the integrity of the base images
- Regularly update dependencies to patch security vulnerabilities
- Follow best practices for securing your Docker builds
- Never include sensitive information in your Docker images