<p align="center"><img src="Assets/CodexQuotaIcon.png" width="112" alt="Ícone da aplicação Cota do Codex"></p>

<h1 align="center">Cota do Codex para macOS</h1>
<p align="center">Consulte a cota do ChatGPT Codex quase em tempo real: atualização automática a cada minuto e manual a qualquer momento.</p>
<p align="center"><img src="https://img.shields.io/badge/macOS-13%2B-111111?logo=apple&logoColor=white" alt="macOS 13 ou posterior"> <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white" alt="Swift 5.9 ou posterior"> <img src="https://img.shields.io/badge/version-1.4.1-007AFF" alt="Versão 1.4.1"></p>

<p align="center">🇬🇧 <a href="README.md">English</a> · 🇨🇳 <a href="README.zh-CN.md">简体中文</a> · 🇨🇳 <a href="README.zh-TW.md">繁體中文</a> · 🇷🇺 <a href="README.ru.md">Русский</a> · 🇫🇷 <a href="README.fr.md">Français</a> · 🇩🇪 <a href="README.de.md">Deutsch</a> · 🇮🇹 <a href="README.it.md">Italiano</a> · 🇯🇵 <a href="README.ja.md">日本語</a> · 🇰🇷 <a href="README.ko.md">한국어</a> · 🇵🇹 <a href="README.pt.md">Português</a> · 🇪🇸 <a href="README.es.md">Español</a></p>

## Visão geral

Uma aplicação leve para a barra de menus do ChatGPT Codex. Consulte os limites disponíveis, os créditos de reposição e os tempos de recuperação sem interromper o trabalho.

## Capturas de ecrã

| Janela da barra de menus | Janela flutuante |
| --- | --- |
| <img src="Assets/Screenshots/menu-bar-popover.png" width="390" alt="Janela da barra de menus"> | <img src="Assets/Screenshots/floating-window.png" width="390" alt="Janela flutuante"> |

As capturas mostram a interface em chinês simplificado. A app segue as preferências de idioma do macOS.

## Funcionalidades principais

| Área | Funcionalidades |
| --- | --- |
| Barra de menus | Nó ChatGPT monocromático: completo a 100%, desvanece de cima para baixo à medida que o limite de 5 horas diminui |
| Ícone da aplicação | Base branca arredondada com nó ChatGPT em grafite e preenchimento monocromático do nível de quota |
| Estado dos limites | Barras de progresso para limites de 5 horas e semanais, tempos de recuperação e créditos disponíveis |
| Janelas | Popover Liquid Glass na barra de menus e uma janela flutuante independente e móvel |
| Atualizações | Atualização automática a cada minuto; confirmação antes de utilizar uma reposição |
| Arranque | Agente local opcional que abre a aplicação quando o ChatGPT inicia |
| Idiomas | Inglês, chinês simplificado e tradicional, russo, francês, alemão, italiano, japonês, coreano, português e espanhol |

## Instalação

1. Instale primeiro a aplicação ChatGPT para computador e inicie sessão.
2. Transfira [CodexQuota-macOS.zip](https://github.com/jcxl8/codex-quota-macos/raw/refs/heads/main/CodexQuota-macOS.zip).
3. No Finder, faça duplo clique no ZIP para extrair `CodexQuota.app`. O Finder pode apresentar o nome traduzido.
4. Arraste a aplicação extraída para a pasta **Aplicações (Applications)** do Finder. **⌘⇧A** abre esta pasta. Instale a aplicação antes de a iniciar; não a abra diretamente em Descargas ou na pasta de extração.
5. Abra a aplicação a partir de **Aplicações**. O ícone e a percentagem aparecem na barra de menus; é normal não aparecer um ícone na Dock.
6. Opcional: abra as **Definições** da aplicação e ative **Abrir ao iniciar o ChatGPT**.

A aplicação tem assinatura local e não foi reconhecida pela Apple. Se o macOS bloquear a primeira abertura, aceda a **Definições do Sistema → Privacidade e segurança**, encontre o aviso da aplicação bloqueada, escolha **Abrir mesmo assim** e confirme. Utilize este procedimento apenas para a aplicação transferida deste repositório.

Requer macOS 13 ou posterior. O Liquid Glass está disponível a partir do macOS 26; as versões anteriores utilizam o material do sistema.

## Compilação

A compilação requer Xcode 26 ou posterior e o compilador Icon Composer incluído. Requer macOS e Swift 5.9 ou posterior. Execute o script de compilação incluído no Terminal para criar a aplicação e executar as verificações integradas.

## Privacidade

A aplicação lê os dados dos limites através do Codex CLI incluído na aplicação de ambiente de trabalho ChatGPT. Não recolhe nem carrega dados, não guarda tokens de acesso e não envia pedidos a modelos. Um crédito só é consumido depois de selecionar a reposição e confirmar. É necessário instalar o ChatGPT e iniciar sessão. A aplicação tem assinatura local e não foi reconhecida pela Apple.
