<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex 額度應用程式圖示"></p>

<h1 align="center">Codex 額度監視器（macOS）</h1>
<p align="center">即時查看 ChatGPT Codex 額度——每分鐘自動重新整理，也可隨時手動重新整理。</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 或更新版本"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 或更新版本"> <img src="https://img.shields.io/badge/version-1.4.1-007AFF" alt="版本 1.4.1"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a> · 🇪🇸 <a href="README.es.md">Español</a></p>

## 專案簡介

輕量級 ChatGPT Codex 選單列應用程式。無須中斷工作，即可查看可用額度、重置機會和恢復時間。

## 主要功能

| 區域 | 功能 |
| --- | --- |
| 選單列 | 單色 ChatGPT 結形圖示：100% 時完整顯示，5 小時額度減少時由上往下逐漸變淡 |
| 應用程式圖示 | 白色圓角底與深灰 ChatGPT 結形標記，保留單色水位填充效果 |
| 額度狀態 | 以進度條呈現 5 小時和每週額度、恢復時間與可用重置次數 |
| 視窗 | Liquid Glass 選單列彈出視窗，以及可單獨拖曳的浮動視窗 |
| 更新 | 每分鐘自動更新；使用重置機會前要求確認 |
| 啟動方式 | 可選啟用本機背景監聽，在 ChatGPT 啟動時自動開啟額度應用程式 |
| 語言 | 跟隨 macOS 偏好語言，支援英文、簡體中文、繁體中文、俄文、法文、德文、義大利文、日文、韓文、葡萄牙文和西班牙文 |

## 安裝

1. 先安裝 ChatGPT 桌面應用程式，並登入帳號。
2. 下載 [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip)。
3. 在 Finder 中按兩下 ZIP 壓縮檔，解壓縮取得 `CodexQuota.app`。Finder 可能依系統語言顯示本地化名稱。
4. 將解壓縮後的 App **拖曳到 Finder 的 Applications（應用程式）檔案夾**。在 Finder 中按 **⌘⇧A** 可開啟該檔案夾。先完成安裝，再啟動；不要直接從下載或解壓縮的檔案夾開啟 App。
5. 從 **Applications（應用程式）** 檔案夾開啟 App。圖示與百分比會出現在選單列；這是選單列應用程式，沒有 Dock 圖示是正常現象。
6. 選用：開啟應用程式內的「設定」，啟用「ChatGPT 啟動時開啟」。

應用程式使用本機簽章，尚未經過 Apple 公證。若 macOS 首次阻止開啟，請前往 **系統設定 → 隱私權與安全性**，找到遭阻止應用程式的提示，按 **強制打開**，並確認後續提示。僅對從本儲存庫下載的應用程式執行此操作。

支援 macOS 13 及更新版本。macOS 26 及更新版本使用 Liquid Glass，較早版本使用系統材質。

## 建置

建置需要 Xcode 26 或更新版本及其 Icon Composer 編譯工具。需要 macOS 和 Swift 5.9 或更新版本。在終端機執行專案內附的建置指令碼，即可產生應用程式並執行內建檢查。

## 隱私

應用程式透過 ChatGPT 桌面應用程式內建的 Codex CLI 讀取額度，不會收集或上傳資料、不會儲存存取權杖，也不會發送模型請求。只有選擇「使用重置」並確認後，才會消耗一次重置機會。需要安裝 ChatGPT 並保持登入。應用程式使用本機簽章，尚未經過 Apple 公證。
