#!/bin/bash
set -e

# Always run from script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

ENV_FILE="${1:-platform/dev/values.env}"

echo "Using environment config: $ENV_FILE"

if [ ! -f "$ENV_FILE" ]; then
  echo "Environment file not found at $ENV_FILE"
  exit 1
fi

export $(grep -v '^#' "$ENV_FILE" | xargs)

echo "Stopping old container if exists..."
sudo docker stop atlas-cloud || true
sudo docker rm atlas-cloud || true

echo "Building image..."
sudo docker build -t atlas-ai -f docker/Dockerfile .

echo "Starting container with ATLAS_ENV=$ATLAS_ENV"
sudo docker run -d \
  -p 8000:8000 \
  --env ATLAS_ENV=$ATLAS_ENV \
  --env LOG_LEVEL=$LOG_LEVEL \
  --name atlas-cloud \
  atlas-ai
