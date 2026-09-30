<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex 额度应用图标"></p>

<h1 align="center">Codex 额度监视器（macOS）</h1>
<p align="center">随时查看 ChatGPT Codex 额度状态。</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 或更新版本"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 或更新版本"> <img src="https://img.shields.io/badge/version-1.4.0-007AFF" alt="版本 1.4.0"></p>

<p align="center">🇺🇸 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇷🇺 <a href="README.ru.md">Русский</a></p>

## 项目简介

轻量级 ChatGPT Codex 菜单栏应用。无需中断工作，即可查看可用额度、重置机会和恢复时间。

## 主要功能

| 区域 | 功能 |
| --- | --- |
| 菜单栏 | ChatGPT 风格图标与当前 5 小时额度结合显示 |
| 额度状态 | 进度条显示 5 小时和每周额度、恢复时间与可用重置次数 |
| 窗口 | Liquid Glass 菜单栏弹窗，以及可单独拖动的浮窗 |
| 更新 | 每分钟自动刷新；使用重置机会前要求确认 |
| 语言 | 跟随 macOS 首选语言，支持英语、简体中文、繁体中文、法语和俄语 |

## 安装

下载 [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip)，解压后打开 CodexQuota.app。Finder 会根据系统语言显示应用名称。若 macOS 首次阻止打开，请在 Finder 中按住 Control 点击应用并选择“打开”。

支持 macOS 13 及更新版本。macOS 26 及更新版本使用 Liquid Glass，较早版本使用系统材质。

## 构建

需要 macOS 和 Swift 5.9 或更新版本。在终端运行项目自带的构建脚本即可生成应用并运行内置检查。

## 隐私

应用通过 ChatGPT 桌面应用内置的 Codex CLI 读取额度，不收集或上传数据、不保存访问令牌，也不发起模型请求。只有选择“使用重置”并确认后，才会消耗一次重置机会。需要安装 ChatGPT 并保持登录。应用使用本地签名，尚未经过 Apple 公证。
