#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")"
swift build
binary_dir=$(swift build --show-bin-path)
app_path="CodexQuota.app"
mkdir -p "$app_path/Contents/MacOS"
cp "$binary_dir/CodexQuota" "$app_path/Contents/MacOS/CodexQuota"
cp Info.plist "$app_path/Contents/Info.plist"
mkdir -p "$app_path/Contents/Resources"
rm -rf "$app_path/Contents/Resources/Contents" "$app_path/Contents/Resources/CodexQuota_CodexQuota.bundle"
cp -R "$binary_dir/CodexQuota_CodexQuota.bundle" "$app_path/Contents/Resources/CodexQuota_CodexQuota.bundle"
cp -R Localizations/*.lproj "$app_path/Contents/Resources/"
iconset_root=$(mktemp -d)
iconset_path="$iconset_root/CodexQuota.iconset"
mkdir -p "$iconset_path"
trap 'rm -rf "$iconset_root"' EXIT
for icon_size in 16 32 128 256 512; do
    sips -s format png -z "$icon_size" "$icon_size" Assets/CodexQuotaIcon.png --out "$iconset_path/icon_${icon_size}x${icon_size}.png" >/dev/null
    retina_size=$((icon_size * 2))
    sips -s format png -z "$retina_size" "$retina_size" Assets/CodexQuotaIcon.png --out "$iconset_path/icon_${icon_size}x${icon_size}@2x.png" >/dev/null
done
rm -f "$app_path/Contents/Resources/CodexQuota.icns"
iconutil -c icns "$iconset_path" -o "$app_path/Contents/Resources/CodexQuota.icns"
codesign --force --sign - "$app_path"
"$binary_dir/CodexQuota" --self-check
