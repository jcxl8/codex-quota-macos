<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex 한도 앱 아이콘"></p>

<h1 align="center">macOS용 Codex 한도</h1>
<p align="center">ChatGPT Codex 한도를 한눈에 확인하세요.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 이상"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 이상"> <img src="https://img.shields.io/badge/version-1.4.1-007AFF" alt="버전 1.4.1"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a> · 🇪🇸 <a href="README.es.md">Español</a></p>

## 개요

ChatGPT Codex를 위한 가벼운 메뉴 막대 앱입니다. 작업을 방해받지 않고 사용 가능한 한도, 초기화 횟수, 회복 시간을 확인할 수 있습니다.

## 주요 기능

| 항목 | 기능 |
| --- | --- |
| 메뉴 막대 | 단색 ChatGPT 매듭: 100%일 때 전체 표시, 5시간 잔여 한도가 줄면 위에서 아래로 점차 흐려짐 |
| 앱 아이콘 | 흰색 둥근 타일과 흑연색 ChatGPT 매듭에 단색 수위 채움 효과 적용 |
| 한도 상태 | 5시간 및 주간 한도 진행률, 회복 시간, 사용 가능한 초기화 횟수 표시 |
| 윈도우 | Liquid Glass 메뉴 막대 팝오버와 별도로 이동할 수 있는 플로팅 윈도우 |
| 업데이트 | 매분 자동 새로고침, 초기화 사용 전 확인 |
| 시작 | ChatGPT가 시작될 때 한도 앱을 여는 선택형 로컬 감시 기능 |
| 언어 | 영어, 중국어(간체·번체), 러시아어, 프랑스어, 독일어, 이탈리아어, 일본어, 한국어, 포르투갈어, 스페인어 |

## 설치

1. 먼저 ChatGPT 데스크톱 앱을 설치하고 로그인하세요.
2. [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip)을 다운로드하세요.
3. Finder에서 ZIP을 두 번 클릭해 `CodexQuota.app`을 압축 해제하세요. Finder에는 현지화된 앱 이름이 표시될 수 있습니다.
4. 압축 해제한 앱을 Finder의 **Applications(응용 프로그램)** 폴더로 드래그하세요. **⌘⇧A**를 누르면 이 폴더가 열립니다. 먼저 설치한 뒤 실행하고, 다운로드 또는 압축 해제 폴더에서 바로 실행하지 마세요.
5. **응용 프로그램** 폴더에서 앱을 여세요. 아이콘과 백분율은 메뉴 막대에 표시됩니다. Dock에 아이콘이 없는 것은 정상입니다.
6. 선택 사항: 앱의 **설정**에서 **ChatGPT 시작 시 열기**를 켜세요.

앱은 로컬 서명되어 있으며 Apple 공증은 받지 않았습니다. macOS가 첫 실행을 차단하면 **시스템 설정 → 개인정보 보호 및 보안**에서 앱 차단 안내를 찾아 **확인 없이 열기**를 선택하고 다음 안내를 확인하세요. 이 저장소에서 다운로드한 앱에만 이 절차를 사용하세요.

macOS 13 이상이 필요합니다. macOS 26 이상에서는 Liquid Glass를 사용하고, 이전 버전에서는 시스템 머티리얼을 사용합니다.

## 빌드

빌드에는 Xcode 26 이상과 포함된 Icon Composer 컴파일러가 필요합니다. macOS와 Swift 5.9 이상이 필요합니다. 포함된 빌드 스크립트를 터미널에서 실행하면 앱을 만들고 내장 검사를 수행합니다.

## 개인정보 보호

앱은 ChatGPT 데스크톱 앱에 포함된 Codex CLI에서 한도 정보를 읽습니다. 데이터를 수집하거나 업로드하지 않고, 액세스 토큰을 저장하거나 모델 요청을 보내지 않습니다. 초기화 횟수는 사용을 선택하고 확인한 경우에만 차감됩니다. ChatGPT를 설치하고 로그인해야 합니다. 앱은 로컬 서명되어 있으며 Apple 공증은 받지 않았습니다.
