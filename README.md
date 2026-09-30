# Codex Quota for macOS

A lightweight macOS menu bar app for monitoring ChatGPT Codex quota. Check your 5-hour and weekly limits, reset credits, and recovery times at a glance.

## Features

- Shows the current 5-hour quota beside the ChatGPT mark in the menu bar.
- Displays 5-hour and weekly quotas as progress bars, with recovery times and available reset credits.
- Provides a Liquid Glass menu bar popover and a separate draggable floating window.
- Refreshes every minute and asks for confirmation before using a reset credit.
- Follows the macOS preferred language: English, Simplified Chinese, Traditional Chinese, French, or Russian. Unsupported languages fall back to English.

## Install

Download [CodexQuota-macOS.zip](CodexQuota-macOS.zip), unzip it, and open `Codex额度.app`. If macOS blocks the app the first time, Control-click it in Finder and choose **Open**.

The app supports macOS 13 and later. Liquid Glass is used on macOS 26 and later; earlier versions use the system material.

## Build

Requires macOS and Swift 5.9 or later. Run:

```sh
./build.sh
```

The build script creates `Codex额度.app` and runs quota parsing and language-selection checks.

## Privacy

The app reads quota details from the Codex CLI bundled with the ChatGPT desktop app. It does not collect or upload data, save access tokens, or send model requests. A reset credit is consumed only after you choose **Use reset** and confirm. ChatGPT must be installed and signed in. The app is locally signed and is not notarized by Apple.

---

# Codex 额度监视器（macOS）

轻量级 macOS 菜单栏应用，用于查看 ChatGPT Codex 额度。可随时查看 5 小时额度、每周额度、可用重置次数和恢复时间。

## 功能

- 在菜单栏的 ChatGPT 图标旁显示当前 5 小时额度。
- 用进度条展示 5 小时和每周额度，并显示恢复时间与可用重置次数。
- 提供 Liquid Glass 风格的菜单栏弹窗和可拖动的独立浮窗。
- 每分钟自动刷新；使用重置机会前会再次确认。
- 跟随 macOS 首选语言：英语、简体中文、繁体中文、法语或俄语；其他语言回退到英语。

## 安装

下载 [CodexQuota-macOS.zip](CodexQuota-macOS.zip)，解压后打开 `Codex额度.app`。如果 macOS 首次阻止打开，请在 Finder 中按住 Control 点击应用并选择“打开”。

支持 macOS 13 及更新版本。macOS 26 及更新版本使用 Liquid Glass，较早版本使用系统材质。

## 构建

需要 macOS 和 Swift 5.9 或更新版本。运行 `./build.sh` 即可构建应用并检查额度解析和语言选择逻辑。

## 隐私

应用通过 ChatGPT 桌面应用内置的 Codex CLI 读取额度，不收集或上传数据、不保存访问令牌，也不发起模型请求。只有选择“使用重置”并确认后，才会消耗一次重置机会。需要安装 ChatGPT 并保持登录。应用使用本地签名，尚未经过 Apple 公证。

## Project description & keywords / 项目简介与关键词

**Description (English):** A macOS menu bar utility that tracks ChatGPT Codex quota, reset credits, and recovery times with Liquid Glass popovers.

**简介（中文）：** 一款 macOS 菜单栏额度监视器，可查看 ChatGPT Codex 额度、重置机会和恢复时间，并提供 Liquid Glass 弹窗。

**Keywords (English):** ChatGPT Codex, Codex quota, ChatGPT quota, quota monitor, usage tracker, macOS menu bar app, reset credits, SwiftUI, Liquid Glass.

**关键词（中文）：** ChatGPT Codex、Codex 额度、ChatGPT 额度、额度监视器、用量追踪、macOS 菜单栏应用、重置机会、SwiftUI、Liquid Glass。
