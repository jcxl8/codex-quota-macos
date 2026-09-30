#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")"
swift build
binary_dir=$(swift build --show-bin-path)
app_path="Codex额度.app"
mkdir -p "$app_path/Contents/MacOS"
cp "$binary_dir/CodexQuota" "$app_path/Contents/MacOS/CodexQuota"
cp Info.plist "$app_path/Contents/Info.plist"
codesign --force --sign - "$app_path"
"$binary_dir/CodexQuota" --self-check
