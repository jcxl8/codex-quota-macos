<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Codex-Limit App-Symbol"></p>

<h1 align="center">Codex-Limit für macOS</h1>
<p align="center">Deine ChatGPT-Codex-Limits auf einen Blick.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 oder neuer"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 oder neuer"> <img src="https://img.shields.io/badge/version-1.4.0-007AFF" alt="Version 1.4.0"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a></p>

## Überblick

Eine schlanke Menüleisten-App für ChatGPT Codex. Prüfe verfügbare Nutzung, Rücksetzoptionen und Wiederherstellungszeiten, ohne deine Arbeit zu unterbrechen.

## Hauptfunktionen

| Bereich | Funktionen |
| --- | --- |
| Menüleiste | ChatGPT-Knotensymbol, das sich entsprechend dem aktuellen 5-Stunden-Limit füllt |
| App-Symbol | ChatGPT-Knoten mit flüssigkeitsinspirierter Füllung |
| Limitstatus | Fortschrittsbalken für 5-Stunden- und Wochenlimits, Wiederherstellungszeiten und verfügbare Rücksetzungen |
| Fenster | Liquid-Glass-Menüleisten-Popover und separates, verschiebbares Fenster |
| Aktualisierung | Automatisch jede Minute; Bestätigung vor jeder Rücksetzung |
| Sprachen | Englisch, vereinfachtes und traditionelles Chinesisch, Russisch, Französisch, Deutsch, Italienisch, Japanisch, Koreanisch und Portugiesisch |

## Installation

Lade [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip) herunter, entpacke die Datei und öffne CodexQuota.app. Der Finder zeigt den App-Namen in der Systemsprache an. Falls macOS den ersten Start blockiert, klicke im Finder bei gedrückter Ctrl-Taste auf die App und wähle Öffnen.

Erfordert macOS 13 oder neuer. Liquid Glass ist ab macOS 26 verfügbar; ältere Versionen verwenden das Systemmaterial.

## Build

Erfordert macOS und Swift 5.9 oder neuer. Führe das enthaltene Build-Skript im Terminal aus, um die App zu erstellen und die integrierten Prüfungen auszuführen.

## Datenschutz

Die App liest Limitdaten über das mit der ChatGPT-Desktop-App gelieferte Codex CLI. Sie sammelt oder überträgt keine Daten, speichert keine Zugriffstoken und sendet keine Modellanfragen. Eine Rücksetzoption wird erst nach Auswahl und Bestätigung verbraucht. ChatGPT muss installiert sein und du musst angemeldet sein. Die App ist lokal signiert und nicht von Apple notariell beglaubigt.
