#!/usr/bin/env bash
# Creates a clean distributable zip: source + docs, without build output, keys or .git.
set -euo pipefail
cd "$(dirname "$0")/.."
out="${1:-darklet-template.zip}"
rm -f "$out"
zip -r "$out" . \
  -x ".git/*" "build/*" ".dart_tool/*" ".idea/*" "*.iml" ".DS_Store" "*/.DS_Store" \
     "*/Pods/*" "ios/.symlinks/*" "android/.gradle/*" "android/local.properties" \
     "android/app/google-services.json" "ios/Runner/GoogleService-Info.plist" \
     "lib/firebase_options.dart" "*.jks" "*.keystore" "key.properties" \
     "*serviceAccount*.json" ".env*" "node_modules/*" "assets/images/*" "$out"
echo "Created $out"
