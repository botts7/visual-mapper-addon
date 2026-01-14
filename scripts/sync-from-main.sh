#!/bin/bash
#
# Sync Visual Mapper from main repo to addon repo
# Usage: ./sync-from-main.sh [stable|beta]
#
# This script:
# 1. Checks out the appropriate branch from main repo (main for stable, beta for beta)
# 2. Copies the latest code to the addon folder
#
# Branch mapping:
#   stable → visual-mapper:main   → visual-mapper/
#   beta   → visual-mapper:beta   → visual-mapper-beta/
#

set -e

# Configuration
MAIN_REPO="${MAIN_REPO:-../Visual Mapper}"
ADDON_REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Default to beta if not specified
TARGET="${1:-beta}"

if [ "$TARGET" = "stable" ]; then
    TARGET_DIR="$ADDON_REPO/visual-mapper"
    SOURCE_BRANCH="main"
    echo "╔════════════════════════════════════════════╗"
    echo "║  Syncing STABLE from branch: main          ║"
    echo "╚════════════════════════════════════════════╝"
elif [ "$TARGET" = "beta" ]; then
    TARGET_DIR="$ADDON_REPO/visual-mapper-beta"
    SOURCE_BRANCH="beta"
    echo "╔════════════════════════════════════════════╗"
    echo "║  Syncing BETA from branch: beta            ║"
    echo "╚════════════════════════════════════════════╝"
else
    echo "Usage: $0 [stable|beta]"
    echo ""
    echo "  stable - Sync from main branch to visual-mapper/"
    echo "  beta   - Sync from beta branch to visual-mapper-beta/"
    exit 1
fi

# Check main repo exists
if [ ! -d "$MAIN_REPO" ]; then
    echo "Error: Main repo not found at $MAIN_REPO"
    echo "Set MAIN_REPO environment variable to the correct path"
    exit 1
fi

# Save current directory
ORIGINAL_DIR="$(pwd)"

# Checkout the correct branch in main repo
echo ""
echo "→ Switching main repo to branch: $SOURCE_BRANCH"
cd "$MAIN_REPO"
git fetch origin
git checkout "$SOURCE_BRANCH"
git pull origin "$SOURCE_BRANCH"

# Get version from the branch
VERSION=$(cat .build-version)
echo "→ Version: $VERSION"

# Return to addon repo
cd "$ORIGINAL_DIR"

# Sync directories
echo ""
echo "→ Syncing backend..."
rm -rf "$TARGET_DIR/backend"
cp -r "$MAIN_REPO/backend" "$TARGET_DIR/backend"

echo "→ Syncing frontend..."
rm -rf "$TARGET_DIR/frontend"
cp -r "$MAIN_REPO/frontend" "$TARGET_DIR/frontend"

echo "→ Syncing config..."
rm -rf "$TARGET_DIR/config"
cp -r "$MAIN_REPO/config" "$TARGET_DIR/config" 2>/dev/null || mkdir -p "$TARGET_DIR/config"

echo "→ Syncing version files..."
cp "$MAIN_REPO/.build-version" "$TARGET_DIR/.build-version" 2>/dev/null || echo "$VERSION" > "$TARGET_DIR/.build-version"
cp "$MAIN_REPO/requirements.txt" "$TARGET_DIR/requirements.txt" 2>/dev/null || true

# Update version in config.yaml
echo "→ Updating config.yaml version to $VERSION..."
sed -i "s/version: .*/version: $VERSION/" "$TARGET_DIR/config.yaml"

# Update cache bust in Dockerfile
CACHE_BUST=$(date +%Y%m%d%H%M)
echo "→ Updating CACHE_BUST to $CACHE_BUST..."
sed -i "s/CACHE_BUST=.*/CACHE_BUST=$CACHE_BUST/" "$TARGET_DIR/Dockerfile"

echo ""
echo "════════════════════════════════════════════════"
echo "✓ Sync complete!"
echo ""
echo "  Target:  $TARGET_DIR"
echo "  Branch:  $SOURCE_BRANCH"
echo "  Version: $VERSION"
echo "════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Commit: git add -A && git commit -m 'chore: Sync $TARGET from $SOURCE_BRANCH ($VERSION)'"
echo "  3. Push: git push origin master"
echo ""
