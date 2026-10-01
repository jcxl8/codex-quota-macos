#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")"
swift build
binary_dir=$(swift build --show-bin-path)
app_path="CodexQuota.app"
mkdir -p "$app_path/Contents/MacOS"
cp "$binary_dir/CodexQuota" "$app_path/Contents/MacOS/CodexQuota"
cp "$binary_dir/CodexQuotaWatcher" "$app_path/Contents/MacOS/CodexQuotaWatcher"
cp Info.plist "$app_path/Contents/Info.plist"
mkdir -p "$app_path/Contents/Resources"
rm -rf "$app_path/Contents/Resources/Contents" "$app_path/Contents/Resources/CodexQuota_CodexQuota.bundle"
cp -R "$binary_dir/CodexQuota_CodexQuota.bundle" "$app_path/Contents/Resources/CodexQuota_CodexQuota.bundle"
cp -R Localizations/*.lproj "$app_path/Contents/Resources/"
icon_build_root=$(mktemp -d)
trap 'rm -rf "$icon_build_root"' EXIT
rm -f "$app_path/Contents/Resources/CodexQuota.icns"
xcrun actool "$PWD/Assets/Icon.icon" \
    --compile "$PWD/$app_path/Contents/Resources" \
    --platform macosx --minimum-deployment-target 13.0 --app-icon Icon \
    --output-partial-info-plist "$icon_build_root/icon.plist" \
    --output-format human-readable-text --warnings --errors
codesign --force --sign - --identifier local.zheng.codexquota.chatgptwatcher "$app_path/Contents/MacOS/CodexQuotaWatcher"
codesign --force --sign - "$app_path"
"$binary_dir/CodexQuota" --self-check
