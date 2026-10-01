<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex 利用枠アプリのアイコン"></p>

<h1 align="center">Codex 利用枠（macOS）</h1>
<p align="center">ChatGPT Codex の利用状況をひと目で確認。</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 以降"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 以降"> <img src="https://img.shields.io/badge/version-1.4.0-007AFF" alt="バージョン 1.4.0"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a></p>

## 概要

ChatGPT Codex 用の軽量なメニューバーアプリです。作業を中断せずに、利用可能な枠、リセット権、回復時刻を確認できます。

## 主な機能

| 項目 | 内容 |
| --- | --- |
| メニューバー | ChatGPTの結び目アイコンが現在の5時間枠に合わせて塗り上がる |
| アプリアイコン | 液体のような塗りを組み合わせたChatGPTマーク |
| 利用状況 | 5時間枠と週間枠の進捗バー、回復時刻、利用可能なリセット権 |
| ウィンドウ | Liquid Glass のメニューバーポップオーバーと、独立して移動できるフローティングウィンドウ |
| 更新 | 毎分自動更新。リセット権の使用前に確認 |
| 起動 | ChatGPTの起動時に利用枠アプリを開くローカル監視機能（任意） |
| 対応言語 | 英語、中国語（簡体字・繁体字）、ロシア語、フランス語、ドイツ語、イタリア語、日本語、韓国語、ポルトガル語 |

## インストール

[CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip) をダウンロードして展開し、CodexQuota.app を開きます。Finder ではシステム言語に合わせたアプリ名が表示されます。ChatGPTの起動時に開くには、アプリの設定で「ChatGPTの起動時に開く」を有効にしてください。初回起動が macOS にブロックされた場合は、Finder でアプリを Control キーを押しながらクリックし、「開く」を選択してください。

macOS 13 以降が必要です。macOS 26 以降では Liquid Glass を使用し、それ以前のバージョンではシステムマテリアルを使用します。

## ビルド

macOS と Swift 5.9 以降が必要です。付属のビルドスクリプトをターミナルで実行すると、アプリを作成して内蔵チェックを実行します。

## プライバシー

このアプリは ChatGPT デスクトップアプリに含まれる Codex CLI から利用状況を読み取ります。データの収集・アップロード、アクセストークンの保存、モデルへのリクエストは行いません。リセット権は、操作を選択して確認した場合にのみ使用されます。ChatGPT をインストールし、サインインしておく必要があります。アプリはローカル署名されており、Apple の公証は受けていません。
