#!/usr/bin/env bash
# SharpCell — replace the placeholder hosting URL in manifest.xml
# Usage from bash, inside the dist/ folder:
#   ./set-host-url.sh https://csava.github.io/sharpcell/
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <hosting-url>"
  echo "Example: $0 https://csava.github.io/sharpcell/"
  exit 1
fi

URL="$1"
[[ "$URL" != */ ]] && URL="${URL}/"

PLACEHOLDER="https://YOUR-GH-USERNAME.github.io/sharpcell/"
MANIFEST="$(dirname "$0")/manifest.xml"

if ! grep -q "$PLACEHOLDER" "$MANIFEST" 2>/dev/null; then
  echo "Manifest already customised; nothing to do."
  exit 0
fi

# portable sed (handles BSD/macOS and GNU)
if sed --version >/dev/null 2>&1; then
  sed -i "s|${PLACEHOLDER}|${URL}|g" "$MANIFEST"
else
  sed -i '' "s|${PLACEHOLDER}|${URL}|g" "$MANIFEST"
fi

echo "manifest.xml updated to use ${URL}"
echo ""
echo "Next: in Excel, Insert > Add-ins > Upload My Add-in > pick this manifest.xml"
