#!/usr/bin/env bash
# =============================================================================
# ensure-pangle.sh
# =============================================================================
# Ensures the Pangle SDK is present in ios/platform/.
# Safe to run multiple times: if all three items are already present, exits
# immediately without downloading anything.
#
# Usage (manual):
#   ./ios/scripts/ensure-pangle.sh
#
# Called automatically by:
#   npm run prepare:ios   →  npm run build:ios   (local builds)
#   GitHub Actions workflow  (CI builds)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Version pin — update BOTH lines when upgrading Pangle SDK
# ---------------------------------------------------------------------------
PANGLE_VERSION="8.2.0.7"
# Official SDK download URL for Pangle v8.2.0.7
# Get the updated URL from: https://www.pangleglobal.com/publisher/integration
PANGLE_URL="https://lf16-pangle.ibytedtos.com/obj/union-pangle/9bc949683f0ea3497addd676705ceea6.zip"

echo "→  Pangle SDK ${PANGLE_VERSION}"

# ---------------------------------------------------------------------------
# Paths (always relative to repo root, regardless of CWD when called)
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLATFORM_DIR="$REPO_ROOT/ios/platform"

PAG_FW="$PLATFORM_DIR/PAGAdSDK.xcframework"
PAG_BUNDLE="$PLATFORM_DIR/PAGAdSDK.bundle"
TIKTOK_FW="$PLATFORM_DIR/TikTokBusinessSDK.xcframework"

# ---------------------------------------------------------------------------
# Idempotency check — skip download if all three items are already present
# ---------------------------------------------------------------------------
if [ -d "$PAG_FW" ] && [ -d "$PAG_BUNDLE" ] && [ -d "$TIKTOK_FW" ]; then
  echo "✓  Pangle SDK ${PANGLE_VERSION} already present in ios/platform/ — skipping download."
  exit 0
fi

echo "→  Pangle SDK not found. Downloading v${PANGLE_VERSION} …"

# ---------------------------------------------------------------------------
# Download & extract
# ---------------------------------------------------------------------------
TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

ZIP="$TMP_DIR/pangle.zip"
EXTRACT_DIR="$TMP_DIR/pangle"

curl -fsSL --retry 3 --retry-delay 2 -o "$ZIP" "$PANGLE_URL" \
  || { echo "✗  Download failed. Check PANGLE_URL in ensure-pangle.sh." >&2; exit 1; }

mkdir -p "$EXTRACT_DIR"
unzip -q "$ZIP" -d "$EXTRACT_DIR"

# Locate the SDK subfolder (Pangle zips contain an outer folder + SDK/)
SDK_DIR="$(find "$EXTRACT_DIR" -type d -name "SDK" | head -n 1)"

if [ -z "$SDK_DIR" ]; then
  echo "✗  Could not find 'SDK' folder inside the Pangle zip." >&2
  echo "   Pangle may have changed the zip structure. Please update ensure-pangle.sh." >&2
  exit 1
fi

# Validate expected contents before copying
for item in "PAGAdSDK.xcframework" "PAGAdSDK.bundle" "TikTokBusinessSDK.xcframework"; do
  if [ ! -e "$SDK_DIR/$item" ]; then
    echo "✗  Expected '$item' not found inside the Pangle SDK zip." >&2
    exit 1
  fi
done

# Copy to ios/platform/ — use -Rf so partial/stale copies are overwritten cleanly
mkdir -p "$PLATFORM_DIR"
cp -Rf "$SDK_DIR/PAGAdSDK.xcframework"        "$PLATFORM_DIR/"
cp -Rf "$SDK_DIR/PAGAdSDK.bundle"             "$PLATFORM_DIR/"
cp -Rf "$SDK_DIR/TikTokBusinessSDK.xcframework" "$PLATFORM_DIR/"

echo "✓  Pangle SDK ${PANGLE_VERSION} installed:"
echo "     ios/platform/PAGAdSDK.xcframework"
echo "     ios/platform/PAGAdSDK.bundle"
echo "     ios/platform/TikTokBusinessSDK.xcframework"
