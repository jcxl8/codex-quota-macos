<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex Quota app icon"></p>

<h1 align="center">Codex Quota for macOS</h1>
<p align="center">Your ChatGPT Codex limits, at a glance.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 or later"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 or later"> <img src="https://img.shields.io/badge/version-1.4.0-007AFF" alt="Version 1.4.0"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a></p>

## Overview

A lightweight menu bar app for ChatGPT Codex. See your available usage, reset credits, and recovery times without interrupting your work.

## Key Features

| Area | Capabilities |
| --- | --- |
| Menu bar | Monochrome ChatGPT knot: full at 100%, fading from top to bottom as the 5-hour quota decreases |
| App icon | White rounded tile with a graphite ChatGPT knot and a monochrome quota-level fill |
| Quota status | Progress bars for 5-hour and weekly limits, recovery times, and available reset credits |
| Windows | Liquid Glass menu bar popover and a separate draggable floating window |
| Updates | Automatic refresh every minute; confirmation before using a reset credit |
| Launch behavior | Optional local watcher opens the quota app when ChatGPT starts |
| Languages | English, Simplified Chinese, Traditional Chinese, Russian, French, German, Italian, Japanese, Korean, and Portuguese, selected from macOS preferences |

## Installation

Download [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip), unzip it, and open CodexQuota.app. Finder displays the app name in the selected language. To enable automatic opening with ChatGPT, open Settings in the app and turn on Open with ChatGPT. If macOS blocks it on first launch, Control-click the app in Finder and choose Open.

Requires macOS 13 or later. Liquid Glass is available on macOS 26 and later; earlier versions use the system material.

## Build

Building requires Xcode 26 or later with its Icon Composer compiler. Requires macOS and Swift 5.9 or later. Run the included build script from Terminal to create the app and run its built-in checks.

## Privacy

The app reads quota details from the Codex CLI included with the ChatGPT desktop app. It does not collect or upload data, save access tokens, or send model requests. A reset credit is consumed only after you select Use reset and confirm. ChatGPT must be installed and signed in. The app is locally signed and is not notarized by Apple.
