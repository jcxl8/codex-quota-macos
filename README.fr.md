<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Icône de Quota Codex"></p>

<h1 align="center">Quota Codex pour macOS</h1>
<p align="center">Consultez les limites ChatGPT Codex en un coup d’œil.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 ou ultérieur"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 ou ultérieur"> <img src="https://img.shields.io/badge/version-1.4.0-007AFF" alt="Version 1.4.0"></p>

<p align="center">🇺🇸 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇷🇺 <a href="README.ru.md">Русский</a></p>

## Présentation

Une app légère de barre des menus pour ChatGPT Codex. Consultez les quotas disponibles, les crédits de réinitialisation et les heures de récupération sans interrompre votre travail.

## Fonctionnalités principales

| Rubrique | Fonctions |
| --- | --- |
| Barre des menus | Icône inspirée de ChatGPT avec le quota actuel de 5 heures |
| État des quotas | Barres de progression pour les quotas de 5 heures et hebdomadaire, heures de récupération et crédits disponibles |
| Fenêtres | Fenêtre Liquid Glass dans la barre des menus et fenêtre flottante indépendante et déplaçable |
| Actualisation | Mise à jour automatique chaque minute ; confirmation avant toute réinitialisation |
| Langues | Suit la langue préférée de macOS : anglais, chinois simplifié, chinois traditionnel, français ou russe |

## Installation

Téléchargez [l’archive macOS](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip), décompressez-la et ouvrez CodexQuota.app. Le Finder affiche le nom de l’app selon la langue du système. Si macOS bloque le premier lancement, faites un clic droit sur l’app dans le Finder et choisissez Ouvrir.

macOS 13 ou ultérieur est requis. Liquid Glass est disponible à partir de macOS 26 ; les versions précédentes utilisent le matériau système.

## Compilation

macOS et Swift 5.9 ou ultérieur sont requis. Exécutez le script de compilation fourni dans Terminal pour créer l’app et lancer ses vérifications intégrées.

## Confidentialité

L’app lit les quotas depuis Codex CLI fourni avec l’app ChatGPT pour ordinateur. Elle ne collecte ni ne téléverse de données, n’enregistre pas de jetons d’accès et n’envoie aucune requête de modèle. Un crédit n’est utilisé qu’après avoir choisi Réinitialiser et confirmé. ChatGPT doit être installé et connecté. L’app est signée localement et n’est pas notariée par Apple.
