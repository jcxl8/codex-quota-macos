<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Ícone da aplicação Cota do Codex"></p>

<h1 align="center">Cota do Codex para macOS</h1>
<p align="center">Consulte os limites do ChatGPT Codex num relance.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 ou posterior"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 ou posterior"> <img src="https://img.shields.io/badge/version-1.4.0-007AFF" alt="Versão 1.4.0"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a></p>

## Visão geral

Uma aplicação leve para a barra de menus do ChatGPT Codex. Consulte os limites disponíveis, os créditos de reposição e os tempos de recuperação sem interromper o trabalho.

## Funcionalidades principais

| Área | Funcionalidades |
| --- | --- |
| Barra de menus | Nó ChatGPT monocromático: completo a 100%, desvanece de cima para baixo à medida que o limite de 5 horas diminui |
| Ícone da aplicação | Base branca arredondada com nó ChatGPT em grafite e preenchimento monocromático do nível de quota |
| Estado dos limites | Barras de progresso para limites de 5 horas e semanais, tempos de recuperação e créditos disponíveis |
| Janelas | Popover Liquid Glass na barra de menus e uma janela flutuante independente e móvel |
| Atualizações | Atualização automática a cada minuto; confirmação antes de utilizar uma reposição |
| Arranque | Agente local opcional que abre a aplicação quando o ChatGPT inicia |
| Idiomas | Inglês, chinês simplificado e tradicional, russo, francês, alemão, italiano, japonês, coreano e português |

## Instalação

Transfira [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip), descomprima-o e abra CodexQuota.app. O Finder apresenta o nome da aplicação no idioma do sistema. Para abrir a aplicação com o ChatGPT, aceda às Definições e ative Abrir ao iniciar o ChatGPT. Se o macOS bloquear a primeira abertura, clique na aplicação no Finder enquanto mantém a tecla Control premida e escolha Abrir.

Requer macOS 13 ou posterior. O Liquid Glass está disponível a partir do macOS 26; as versões anteriores utilizam o material do sistema.

## Compilação

A compilação requer Xcode 26 ou posterior e o compilador Icon Composer incluído. Requer macOS e Swift 5.9 ou posterior. Execute o script de compilação incluído no Terminal para criar a aplicação e executar as verificações integradas.

## Privacidade

A aplicação lê os dados dos limites através do Codex CLI incluído na aplicação de ambiente de trabalho ChatGPT. Não recolhe nem carrega dados, não guarda tokens de acesso e não envia pedidos a modelos. Um crédito só é consumido depois de selecionar a reposição e confirmar. É necessário instalar o ChatGPT e iniciar sessão. A aplicação tem assinatura local e não foi reconhecida pela Apple.
