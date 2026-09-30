#!/usr/bin/env zsh
set -euo pipefail

mode="${1:-run}"
root_dir="$(cd "$(dirname "$0")/.." && pwd)"
app_bundle="$root_dir/CodexQuota.app"
app_binary="$app_bundle/Contents/MacOS/CodexQuota"

pkill -x CodexQuota >/dev/null 2>&1 || true
"$root_dir/build.sh"

open_app() {
    if (( $# )); then
        /usr/bin/open -n "$app_bundle" --args "$@"
    else
        /usr/bin/open -n "$app_bundle"
    fi
}

case "$mode" in
    run)
        open_app
        ;;
    --panel|panel)
        open_app --show-panel
        ;;
    --popover|popover)
        open_app --show-popover
        ;;
    --debug|debug)
        lldb -- "$app_binary"
        ;;
    --logs|logs)
        open_app
        /usr/bin/log stream --info --style compact --predicate 'process == "CodexQuota"'
        ;;
    --telemetry|telemetry)
        open_app
        /usr/bin/log stream --info --style compact --predicate 'subsystem == "local.zheng.codexquota"'
        ;;
    --verify|verify)
        open_app
        sleep 1
        pgrep -x CodexQuota >/dev/null
        ;;
    *)
        print -u2 "usage: $0 [run|--panel|--popover|--debug|--logs|--telemetry|--verify]"
        exit 2
        ;;
esac
