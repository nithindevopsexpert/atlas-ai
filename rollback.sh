#!/bin/bash
set -e

if [ ! -f .last_good_version ]; then
  echo "No previous version found. Rollback aborted."
  exit 1
fi

VERSION=$(cat .last_good_version)
echo "Rolling back to version $VERSION"

sudo docker stop atlas-cloud || true
sudo docker rm atlas-cloud || true

sudo docker run -d \
  -p 8000:8000 \
  --name atlas-cloud \
  atlas-ai:$VERSION
