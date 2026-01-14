#!/bin/bash
#
# Sync Visual Mapper from main repo to addon repo
# Usage: ./sync-from-main.sh [stable|beta]
#
# This script copies the latest code from the main visual-mapper repo
# to either the stable (visual-mapper/) or beta (visual-mapper-beta/) folder.
#

set -e

# Configuration
MAIN_REPO="${MAIN_REPO:-../visual-mapper}"
ADDON_REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Default to beta if not specified
TARGET="${1:-beta}"

if [ "$TARGET" = "stable" ]; then
    TARGET_DIR="$ADDON_REPO/visual-mapper"
    echo "Syncing to STABLE: $TARGET_DIR"
elif [ "$TARGET" = "beta" ]; then
    TARGET_DIR="$ADDON_REPO/visual-mapper-beta"
    echo "Syncing to BETA: $TARGET_DIR"
else
    echo "Usage: $0 [stable|beta]"
    exit 1
fi

# Check main repo exists
if [ ! -d "$MAIN_REPO" ]; then
    echo "Error: Main repo not found at $MAIN_REPO"
    echo "Set MAIN_REPO environment variable to the correct path"
    exit 1
fi

# Sync directories
echo ""
echo "Syncing backend..."
rm -rf "$TARGET_DIR/backend"
cp -r "$MAIN_REPO/backend" "$TARGET_DIR/backend"

echo "Syncing frontend..."
rm -rf "$TARGET_DIR/frontend"
cp -r "$MAIN_REPO/frontend" "$TARGET_DIR/frontend"

echo "Syncing config..."
rm -rf "$TARGET_DIR/config"
cp -r "$MAIN_REPO/config" "$TARGET_DIR/config" 2>/dev/null || mkdir -p "$TARGET_DIR/config"

echo "Syncing version files..."
cp "$MAIN_REPO/.build-version" "$TARGET_DIR/.build-version"
cp "$MAIN_REPO/requirements.txt" "$TARGET_DIR/requirements.txt" 2>/dev/null || true

# Update cache bust in Dockerfile
CACHE_BUST=$(date +%Y%m%d%H%M)
echo "Updating CACHE_BUST to $CACHE_BUST..."
sed -i "s/CACHE_BUST=.*/CACHE_BUST=$CACHE_BUST/" "$TARGET_DIR/Dockerfile"

echo ""
echo "Sync complete!"
echo ""
echo "Next steps:"
echo "  1. Update version in $TARGET_DIR/config.yaml if needed"
echo "  2. git add -A && git commit -m 'Sync from main repo'"
echo "  3. git push origin master"
