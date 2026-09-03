# 🚀 Fedora Minimal Setup Script — Wayland & Desktop Shells

[![Fedora](https://img.shields.io/badge/Fedora-40%2B-blue?logo=fedora)](https://getfedora.org/)
[![Wayland](https://img.shields.io/badge/Wayland-Niri%20%7C%20Hyprland-orange?logo=wayland)](https://wayland.freedesktop.org/)
[![Hardware](https://img.shields.io/badge/Hardware-Lenovo%20Legion%20Slim%205i-red?logo=lenovo)](https://lenovo.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Um script de instalação e configuração automatizada em **Bash TUI** para transformar o **Fedora Everything (Minimal Install)** em uma estação de trabalho moderna, de alta performance e visual impecável usando compositores **Wayland (Niri ou Hyprland)** e desktop shells (**Noctalia ou Dank Material Shell**).

Projetado sob medida para notebooks de alta performance com placas híbridas, com foco no **Lenovo Legion Slim 5i (Intel i5 13ª Ger. + NVIDIA RTX 3050)**.

---

## 🎨 Destaques do Projeto

- **🖥️ Escolha de Compositor:**
  - **Niri:** Scroll horizontal infinito, janelas organizadas dinamicamente e configurador gráfico **NiriMod** em GTK4.
  - **Hyprland:** Tiling dinâmico clássico com animações ultra-fluidas e cantos arredondados.
  - **Standalone:** Instalação pura sem shell pesado usando **Fuzzel** + **tuigreet**.
- **🌌 Desktop Shells Modernos:**
  - **Noctalia:** Shell minimalista e nativo para Fedora.
  - **Dank Material Shell (DMS):** Interface baseada em Material You completa com painel de controle e notificações.
- **⚡ Seletor de Aplicativos Interativo (TUI):**
  - Menu interativo no terminal (navegação por setas e barra de espaço) para escolher entre 27+ apps categorizados por tipo (`[RPM]`, `[Flatpak]`, `[Script]`).
- **🎮 Drivers e Aceleração de Hardware:**
  - Suporte automático a GPU Híbrida (`switcheroo-control` para alternar Intel / NVIDIA).
  - Driver NVIDIA proprietário + aceleração VA-API (`nvidia-vaapi-driver`).
  - Teclas de atalho FN integradas (Brilho com `brightnessctl`, Mídia com `playerctl`, Volume com `wpctl`).
- **🎥 Screen Sharing & Multimídia Completa:**
  - Suporte a compartilhamento de tela em videochamadas (Discord, Meet, Zoom) via `pipewire-gstreamer` + `xwaylandvideobridge` + XDG Desktop Portals.
  - Codecs H.264, AAC, MP4, WebP, SVG e miniaturas completas para o Nautilus.
- **📸 Screenshots Nativos com Anotação:**
  - Integração com **Satty** + **grim** + **slurp** (anotação rápida, seta, blur e texto) acionado pela tecla `Print`.
  - Ferramenta nativa `niri-shot` para Niri.
- **🛠️ Ambiente de Desenvolvimento:**
  - **FNM (Fast Node Manager):** Gerenciador ultra-rápido de Node.js em Rust integrado ao `.bashrc`.
  - VS Code, Git, Podman (pré-selecionado) e Docker opcional.

---

## 📥 Pré-requisitos e Instalação do Sistema Base

1. **Baixar o Fedora Everything:**
   - Faça o download da ISO **Fedora Everything (Netinstall)** no site oficial do Fedora.
2. **Instalação Minimal:**
   - Durante a instalação do Fedora, na tela de seleção de pacotes/software, escolha a opção **Minimal Install** (sem ambiente GNOME ou KDE padrão).
3. **Secure Boot (Aviso):**
   - Se o Secure Boot estiver ativado na BIOS do seu notebook Lenovo Legion, pode ser necessário desativá-lo para a assinatura dos módulos da NVIDIA (`akmod-nvidia`).

---

## 🚀 Como Executar o Script

Após o primeiro boot na instalação minimalista do Fedora:

```bash
# 1. Clone ou baixe este repositório:
git clone https://github.com/danieldemoura/fedora-shell-setup.git
cd fedora-shell-setup

# 2. Dê permissão de execução ao script:
chmod +x setup.sh

# 3. Execute o instalador:
./setup.sh
```

---

## 📋 Lista de Aplicativos Disponíveis

| Grupo                   | Aplicativo                           | Tipo                 | Padrão |
| :---------------------- | :----------------------------------- | :------------------- | :----: |
| **Navegadores**         | Brave Browser                        | RPM (repo oficial)   |   ✅   |
|                         | Firefox                              | Flatpak              |   ❌   |
| **Terminal & Sistema**  | Kitty Terminal                       | RPM                  |   ✅   |
|                         | Fastfetch                            | RPM                  |   ✅   |
| **GNOME / Utilitários** | Nautilus (Gerenciador de Arquivos)   | RPM                  |   ✅   |
|                         | Calculadora                          | Flatpak              |   ✅   |
|                         | Loupe (Visualizador de Imagens)      | Flatpak              |   ✅   |
|                         | Evince (Leitor de PDF)               | Flatpak              |   ✅   |
|                         | Disks (Gerenciador de Discos)        | Flatpak              |   ✅   |
|                         | SimpleScan (Scanner)                 | Flatpak              |   ✅   |
|                         | Baobab (Analisador de Disco)         | Flatpak              |   ❌   |
|                         | Tabela de Caracteres                 | Flatpak              |   ❌   |
| **Multimídia**          | MPC-QT (Media Player)                | Flatpak              |   ✅   |
|                         | pwvucontrol (Controle de Áudio GTK4) | Flatpak              |   ✅   |
|                         | VLC Media Player                     | Flatpak              |   ❌   |
| **Comunicação**         | Discord                              | Flatpak              |   ❌   |
|                         | Telegram Desktop                     | Flatpak              |   ❌   |
|                         | WhatsApp (ZapZap)                    | Flatpak              |   ❌   |
| **Utilitários**         | Warehouse (Gerenciador Flatpak)      | Flatpak              |   ✅   |
|                         | Flatseal (Gerenciador de Permissões) | Flatpak              |   ❌   |
| **Desenvolvimento**     | Dev Toolbox                          | Flatpak              |   ❌   |
|                         | Visual Studio Code                   | RPM (repo Microsoft) |   ✅   |
|                         | Git                                  | RPM                  |   ✅   |
|                         | Node.js (via FNM)                    | Script (curl)        |   ✅   |
|                         | Podman Containers                    | RPM                  |   ✅   |
|                         | Distrobox                            | RPM                  |   ❌   |
|                         | Docker Engine                        | RPM                  |   ❌   |

---

## ⌨️ Teclas de Atalho Padrão (Cheat Sheet)

> A tecla `Mod` corresponde à tecla **Super / Windows**.

| Atalho            | Ação                                              |
| :---------------- | :------------------------------------------------ |
| `Mod + Return`    | Abre o Terminal (**Kitty**)                       |
| `Mod + E`         | Abre o Gerenciador de Arquivos (**Nautilus**)     |
| `Mod + B`         | Abre o Navegador (**Brave**)                      |
| `Mod + Q`         | Fecha a janela ativa                              |
| `Mod + D`         | Launcher de aplicativos (Fuzzel)                  |
| `Mod + Shift + C` | Abre o configurador gráfico **NiriMod** (se Niri) |
| `Print`           | Captura de tela inteira com **Satty**             |
| `Shift + Print`   | Captura de região com **Satty** / `niri-shot`     |
| `Fn + Volume`     | Aumenta / diminui / muta áudio via `wpctl`        |
| `Fn + Brilho`     | Ajusta o brilho da tela via `brightnessctl`       |
| `Fn + Mídia`      | Play / Pause / Próxima faixa via `playerctl`      |

---

## 📁 Estrutura do Repositório

```
.
├── setup.sh                     # Script Bash interativo principal (TUI)
├── configs/                     # Templates de Dotfiles pré-configurados
│   ├── niri-config.kdl          # Configuração base do Niri (Layout, atalhos, FN keys)
│   ├── hyprland.conf            # Configuração base do Hyprland (Bordas, blur, atalhos)
│   ├── portals-niri.conf        # Configuração de XDG Desktop Portal para Niri
│   └── portals-hyprland.conf    # Configuração de XDG Desktop Portal para Hyprland
└── docs/                        # Documentação técnica e histórico de decisões
    ├── plano_de_implementacao.md
    └── plano_de_implementacao_v3.md
```

---

## 📜 Licença

Este projeto é disponibilizado sob a licença [MIT](LICENSE). Sinta-se livre para adaptar e redistribuir!
