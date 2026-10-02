<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex 额度应用图标"></p>

<h1 align="center">Codex 额度监视器（macOS）</h1>
<p align="center">随时查看 ChatGPT Codex 额度状态。</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 或更新版本"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 或更新版本"> <img src="https://img.shields.io/badge/version-1.4.1-007AFF" alt="版本 1.4.1"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a> · 🇪🇸 <a href="README.es.md">Español</a></p>

## 项目简介

轻量级 ChatGPT Codex 菜单栏应用。无需中断工作，即可查看可用额度、重置机会和恢复时间。

## 主要功能

| 区域 | 功能 |
| --- | --- |
| 菜单栏 | 单色 ChatGPT 结形图标：100% 时完整显示，5 小时额度减少时从上往下逐渐变淡 |
| 应用图标 | 白色圆角底与深灰 ChatGPT 结形标记，保留单色水位填充效果 |
| 额度状态 | 进度条显示 5 小时和每周额度、恢复时间与可用重置次数 |
| 窗口 | Liquid Glass 菜单栏弹窗，以及可单独拖动的浮窗 |
| 更新 | 每分钟自动刷新；使用重置机会前要求确认 |
| 启动方式 | 可选启用本地后台监听，在 ChatGPT 启动时自动打开额度应用 |
| 语言 | 跟随 macOS 首选语言，支持英语、简体中文、繁体中文、俄语、法语、德语、意大利语、日语、韩语、葡萄牙语和西班牙语 |

## 安装

1. 先安装 ChatGPT 桌面应用，并登录账号。
2. 下载 [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip)。
3. 在 Finder 中双击 ZIP 压缩包，解压得到 `CodexQuota.app`。Finder 可能按系统语言显示本地化名称。
4. 将解压后的 App **拖放到 Finder 的 Applications（应用程序）文件夹**。在 Finder 中按 **⌘⇧A** 可打开该文件夹。先完成安装，再启动；不要直接从下载目录或解压目录打开 App。
5. 从 **Applications（应用程序）** 文件夹打开 App。图标与百分比会出现在状态栏；这是菜单栏应用，没有 Dock 图标属于正常现象。
6. 可选：打开应用内的「设置」，开启「ChatGPT 启动时打开」。

应用使用本地签名，尚未经过 Apple 公证。若 macOS 首次阻止打开，请进入 **系统设置 → 隐私与安全性**，找到被阻止应用的提示，点击 **仍要打开**，并确认后续提示。仅对从本仓库下载的应用执行此操作。

支持 macOS 13 及更新版本。macOS 26 及更新版本使用 Liquid Glass，较早版本使用系统材质。

## 构建

构建需要 Xcode 26 或更新版本及其 Icon Composer 编译工具。需要 macOS 和 Swift 5.9 或更新版本。在终端运行项目自带的构建脚本即可生成应用并运行内置检查。

## 隐私

应用通过 ChatGPT 桌面应用内置的 Codex CLI 读取额度，不收集或上传数据、不保存访问令牌，也不发起模型请求。只有选择“使用重置”并确认后，才会消耗一次重置机会。需要安装 ChatGPT 并保持登录。应用使用本地签名，尚未经过 Apple 公证。
