#!/bin/bash
set -e

# Ensure osmium is installed
if ! command -v osmium &> /dev/null; then
  echo "Installing osmium-tool..."
  sudo apt update
  sudo apt install -y osmium-tool
fi

mkdir -p data

# Optional: download countries if not already present
# Uncomment or customize as needed
# echo "Downloading .pbf files..."
# wget -q -nc -O data/brazil.pbf https://download.geofabrik.de/south-america/brazil-latest.osm.pbf || true
wget -nc -O data/chile.pbf https://download.geofabrik.de/south-america/chile-latest.osm.pbf || true
wget -nc -O data/portugal.pbf https://download.geofabrik.de/europe/portugal-latest.osm.pbf || true

echo "Looking for .pbf files in ./data..."
PBF_FILES=$(find data/ -type f -name "*.pbf" ! -name "combined.pbf")

if [ -z "$PBF_FILES" ]; then
  echo "❌ No .pbf files found to merge in ./data"
  exit 1
fi

echo "Merging $PBF_FILES..."
osmium merge $PBF_FILES -o data/combined.pbf --overwrite
echo "✅ Done: data/combined.pbf created from:"
echo "$PBF_FILES"

docker compose up -d
