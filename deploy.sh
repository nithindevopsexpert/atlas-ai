#!/bin/bash
set -e

# Always run from script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Environment config (default = dev)
ENV_FILE="${1:-platform/dev/values.env}"

echo "Using environment config: $ENV_FILE"

if [ ! -f "$ENV_FILE" ]; then
  echo "Environment file not found at $ENV_FILE"
  exit 1
fi

# Load environment variables
export $(grep -v '^#' "$ENV_FILE" | xargs)

# Capture currently running version (if any)
LAST_VERSION=$(sudo docker inspect -f '{{ index .Config.Labels "atlas.version" }}' atlas-cloud 2>/dev/null || true)
if [ -n "$LAST_VERSION" ]; then
  echo "Saving last known good version: $LAST_VERSION"
  echo "$LAST_VERSION" > .last_good_version
fi

# Determine image version (CI provides GITHUB_SHA)
IMAGE_TAG="${GITHUB_SHA:-latest}"

echo "Deploying Atlas version: $IMAGE_TAG"

echo "Stopping old container if exists..."
sudo docker stop atlas-cloud || true
sudo docker rm atlas-cloud || true

echo "Building image atlas-ai:$IMAGE_TAG ..."
sudo docker build -t atlas-ai:$IMAGE_TAG -f docker/Dockerfile .

echo "Starting container with ATLAS_ENV=$ATLAS_ENV"
sudo docker run -d \
  -p 8000:8000 \
  --env ATLAS_ENV=$ATLAS_ENV \
  --env LOG_LEVEL=$LOG_LEVEL \
  --label atlas.version=$IMAGE_TAG \
  --name atlas-cloud \
  atlas-ai:$IMAGE_TAG

