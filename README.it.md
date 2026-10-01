<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Icon dell’app Limite Codex"></p>

<h1 align="center">Limite Codex per macOS</h1>
<p align="center">Tieni sotto controllo i limiti di ChatGPT Codex.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 o successivo"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 o successivo"> <img src="https://img.shields.io/badge/version-1.4.0-007AFF" alt="Versione 1.4.0"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a></p>

## Panoramica

Un’app leggera per la barra dei menu di ChatGPT Codex. Controlla i limiti disponibili, i crediti di ripristino e i tempi di recupero senza interrompere il lavoro.

## Funzionalità principali

| Area | Funzioni |
| --- | --- |
| Barra dei menu | L’icona a nodo di ChatGPT si riempie in base al limite attuale di 5 ore |
| Icona dell’app | Simbolo ChatGPT con un riempimento ispirato a un liquido |
| Stato dei limiti | Barre di avanzamento per i limiti di 5 ore e settimanali, tempi di recupero e crediti disponibili |
| Finestre | Popover Liquid Glass nella barra dei menu e finestra mobile indipendente |
| Aggiornamenti | Aggiornamento automatico ogni minuto; conferma prima di usare un credito |
| Avvio | Un agente locale facoltativo apre l’app all’avvio di ChatGPT |
| Lingue | Inglese, cinese semplificato e tradizionale, russo, francese, tedesco, italiano, giapponese, coreano e portoghese |

## Installazione

Scarica [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip), decomprimilo e apri CodexQuota.app. Il Finder mostra il nome dell’app nella lingua del sistema. Per aprire l’app insieme a ChatGPT, vai nelle Impostazioni e attiva Apri all’avvio di ChatGPT. Se macOS blocca il primo avvio, fai clic sull’app nel Finder tenendo premuto Control e scegli Apri.

Richiede macOS 13 o successivo. Liquid Glass è disponibile da macOS 26; le versioni precedenti usano il materiale di sistema.

## Compilazione

Richiede macOS e Swift 5.9 o successivo. Esegui lo script di compilazione incluso dal Terminale per creare l’app e avviare i controlli integrati.

## Privacy

L’app legge i dati dei limiti dal Codex CLI incluso nell’app ChatGPT per desktop. Non raccoglie né carica dati, non salva token di accesso e non invia richieste ai modelli. Un credito viene consumato solo dopo aver scelto il ripristino e aver confermato. ChatGPT deve essere installato e devi aver effettuato l’accesso. L’app è firmata localmente e non è autenticata da Apple.
