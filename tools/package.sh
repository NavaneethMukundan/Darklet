#!/usr/bin/env bash
# Creates a clean distributable zip: source + docs, without build output, keys or .git.
# Files that hold YOUR project's Firebase values (lib/firebase_options.dart and
# ios/Runner/Info.plist) are replaced by the placeholder versions from git HEAD,
# so your keys never reach buyers.
set -euo pipefail
cd "$(dirname "$0")/.."
case "${1:-darklet-template.zip}" in
  /*) out="${1}" ;;
  *) out="$(pwd)/${1:-darklet-template.zip}" ;;
esac
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

rsync -a \
  --exclude '.git' --exclude 'build' --exclude '.dart_tool' --exclude '.idea' --exclude '*.iml' \
  --exclude '.DS_Store' --exclude 'Pods' --exclude 'ios/.symlinks' --exclude 'android/.gradle' \
  --exclude 'android/.kotlin' --exclude 'android/local.properties' \
  --exclude 'android/app/google-services.json' --exclude 'ios/Runner/GoogleService-Info.plist' \
  --exclude '*.jks' --exclude '*.keystore' --exclude 'key.properties' \
  --exclude '*serviceAccount*.json' --exclude '*adminsdk*.json' --exclude '.env*' \
  --exclude 'node_modules' --exclude 'assets/images' --exclude '*.zip' \
  ./ "$stage/"

for f in lib/firebase_options.dart ios/Runner/Info.plist; do
  git show "HEAD:$f" > "$stage/$f"
done

rm -f "$out"
(cd "$stage" && zip -qr "$out" .)
echo "Created $out"
