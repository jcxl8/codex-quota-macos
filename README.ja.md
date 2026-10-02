<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex 利用枠アプリのアイコン"></p>

<h1 align="center">Codex 利用枠（macOS）</h1>
<p align="center">ChatGPT Codex の利用枠をほぼリアルタイムで確認。毎分自動更新、いつでも手動で更新できます。</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 以降"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 以降"> <img src="https://img.shields.io/badge/version-1.4.1-007AFF" alt="バージョン 1.4.1"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a> · 🇪🇸 <a href="README.es.md">Español</a></p>

## 概要

ChatGPT Codex 用の軽量なメニューバーアプリです。作業を中断せずに、利用可能な枠、リセット権、回復時刻を確認できます。

## 主な機能

| 項目 | 内容 |
| --- | --- |
| メニューバー | 単色のChatGPT結び目：100%では全体を表示し、5時間の残り利用枠が減ると上から下へ薄くなる |
| アプリアイコン | 白い角丸タイルとダークグレーのChatGPT結び目に、単色の水位による塗りつぶし効果 |
| 利用状況 | 5時間枠と週間枠の進捗バー、回復時刻、利用可能なリセット権 |
| ウィンドウ | Liquid Glass のメニューバーポップオーバーと、独立して移動できるフローティングウィンドウ |
| 更新 | 毎分自動更新。リセット権の使用前に確認 |
| 起動 | ChatGPTの起動時に利用枠アプリを開くローカル監視機能（任意） |
| 対応言語 | 英語、中国語（簡体字・繁体字）、ロシア語、フランス語、ドイツ語、イタリア語、日本語、韓国語、ポルトガル語、スペイン語 |

## インストール

1. 先にChatGPTデスクトップアプリをインストールし、サインインします。
2. [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip) をダウンロードします。
3. FinderでZIPをダブルクリックし、`CodexQuota.app` を展開します。Finderにはローカライズされた名前が表示される場合があります。
4. 展開したアプリをFinderの **Applications（アプリケーション）** フォルダへドラッグします。**⌘⇧A** でこのフォルダを開けます。インストールしてから起動し、ダウンロード先や展開先から直接起動しないでください。
5. **アプリケーション** フォルダからアプリを開きます。アイコンと残りの割合はメニューバーに表示されます。Dockにアイコンが出ないのは正常です。
6. 任意：アプリの **設定** で **ChatGPTの起動時に開く** を有効にします。

アプリはローカル署名されており、Appleの公証は受けていません。初回起動がブロックされた場合は、**システム設定 → プライバシーとセキュリティ** でブロックされたアプリの通知を探し、**このまま開く** を選択して確認します。この手順は本リポジトリからダウンロードしたアプリにのみ使用してください。

macOS 13 以降が必要です。macOS 26 以降では Liquid Glass を使用し、それ以前のバージョンではシステムマテリアルを使用します。

## ビルド

ビルドにはXcode 26以降と付属のIcon Composerコンパイラが必要です。macOS と Swift 5.9 以降が必要です。付属のビルドスクリプトをターミナルで実行すると、アプリを作成して内蔵チェックを実行します。

## プライバシー

このアプリは ChatGPT デスクトップアプリに含まれる Codex CLI から利用状況を読み取ります。データの収集・アップロード、アクセストークンの保存、モデルへのリクエストは行いません。リセット権は、操作を選択して確認した場合にのみ使用されます。ChatGPT をインストールし、サインインしておく必要があります。アプリはローカル署名されており、Apple の公証は受けていません。
