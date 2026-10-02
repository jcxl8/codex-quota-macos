<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Icône de Quota Codex"></p>

<h1 align="center">Quota Codex pour macOS</h1>
<p align="center">Suivez les quotas ChatGPT Codex en quasi-temps réel : actualisation automatique chaque minute et manuelle à tout moment.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 ou ultérieur"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 ou ultérieur"> <img src="https://img.shields.io/badge/version-1.4.1-007AFF" alt="Version 1.4.1"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a> · 🇪🇸 <a href="README.es.md">Español</a></p>

## Présentation

Une app légère de barre des menus pour ChatGPT Codex. Consultez les quotas disponibles, les crédits de réinitialisation et les heures de récupération sans interrompre votre travail.

## Fonctionnalités principales

| Rubrique | Fonctions |
| --- | --- |
| Barre des menus | Nœud ChatGPT monochrome : complet à 100 %, il s’estompe du haut vers le bas lorsque le quota de 5 heures diminue |
| Icône de l’app | Tuile blanche arrondie avec un nœud ChatGPT graphite et un remplissage monochrome indiquant le niveau de quota |
| État des quotas | Barres de progression pour les quotas de 5 heures et hebdomadaire, heures de récupération et crédits disponibles |
| Fenêtres | Fenêtre Liquid Glass dans la barre des menus et fenêtre flottante indépendante et déplaçable |
| Actualisation | Mise à jour automatique chaque minute ; confirmation avant toute réinitialisation |
| Démarrage | Agent local facultatif qui ouvre l’app de quotas au lancement de ChatGPT |
| Langues | Suit la langue préférée de macOS : anglais, chinois simplifié, chinois traditionnel, russe, français, allemand, italien, japonais, coréen, portugais ou espagnol |

## Installation

1. Installez d’abord l’app ChatGPT pour ordinateur et connectez-vous.
2. Téléchargez [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip).
3. Dans le Finder, double-cliquez sur le ZIP pour extraire `CodexQuota.app`. Le Finder peut afficher son nom localisé.
4. Faites glisser l’app extraite dans le dossier **Applications** du Finder. Le raccourci **⌘⇧A** ouvre ce dossier. Installez l’app avant de la lancer ; ne l’ouvrez pas directement depuis Téléchargements ou le dossier d’extraction.
5. Ouvrez l’app depuis **Applications**. L’icône et le pourcentage apparaissent dans la barre des menus ; l’absence d’icône dans le Dock est normale.
6. Facultatif : ouvrez les **Réglages** de l’app et activez **Ouvrir au lancement de ChatGPT**.

L’app est signée localement et n’est pas notariée par Apple. Si macOS bloque le premier lancement, ouvrez **Réglages Système → Confidentialité et sécurité**, trouvez l’avis de blocage, cliquez sur **Ouvrir quand même**, puis confirmez. Réservez cette procédure à l’app téléchargée depuis ce dépôt.

macOS 13 ou ultérieur est requis. Liquid Glass est disponible à partir de macOS 26 ; les versions précédentes utilisent le matériau système.

## Compilation

La compilation nécessite Xcode 26 ou ultérieur et son compilateur Icon Composer. macOS et Swift 5.9 ou ultérieur sont requis. Exécutez le script de compilation fourni dans Terminal pour créer l’app et lancer ses vérifications intégrées.

## Confidentialité

L’app lit les quotas depuis Codex CLI fourni avec l’app ChatGPT pour ordinateur. Elle ne collecte ni ne téléverse de données, n’enregistre pas de jetons d’accès et n’envoie aucune requête de modèle. Un crédit n’est utilisé qu’après avoir choisi Réinitialiser et confirmé. ChatGPT doit être installé et connecté. L’app est signée localement et n’est pas notariée par Apple.
