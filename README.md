# 🚀 Fedora Minimal Base Setup Script — Dank Material Shell & Wayland

[![Fedora](https://img.shields.io/badge/Fedora-40%2B-blue?logo=fedora)](https://getfedora.org/)
[![Wayland](https://img.shields.io/badge/Wayland-Niri%20%7C%20Hyprland-orange?logo=wayland)](https://wayland.freedesktop.org/)
[![Hardware](https://img.shields.io/badge/Hardware-Universal%20(Intel%20%7C%20AMD%20%7C%20NVIDIA)-green)](https://fedoraproject.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Um script de instalação automatizada e modular em Bash para transformar o **Fedora Everything (Minimal Install)** em um sistema base limpo, ultra-rápido e 100% funcional "out-of-the-box" (como Ubuntu/Linux Mint), encadeando no final a instalação oficial do **Dank Material Shell (DMS)** para escolha do seu compositor Wayland favorito (**Niri** ou **Hyprland**).

---

## 🎨 Destaques do Projeto

- **⚡ Instalação Limpa e Minimalista:**
  - Parte do **Fedora Minimal Install** (sem GNOME Shell pesado, sem mineradores de busca ou bloatware).
  - Sistema 100% limpo: **sem aplicativos pessoais ou de desenvolvimento pré-instalados**. Você escolhe o que instalar na pós-instalação.
- **🖥️ Compatibilidade Universal de Hardware & GPU Híbrida:**
  - Detecção inteligente via `lspci` de placas de vídeo (NVIDIA, AMD ou Intel) e instalação automática dos drivers adequados (ex: `akmod-nvidia` + `nvidia-vaapi-driver`).
  - Suporte e ativação automática do **`switcheroo-control`** para alternância dinâmica D-Bus entre GPU integrada (Intel/AMD) e GPU dedicada (NVIDIA).
  - Gerenciamento adaptativo de energia (ajustes para notebook vs desktop).
- **🎵 Áudio, Conectividade e Codecs Totais:**
  - Áudio PipeWire + WirePlumber + controle GTK4 `pwvucontrol`.
  - Bluetooth com `bluez` + `blueman` e Wi-Fi / Rede com `NetworkManager`.
  - Codecs multimídia 100% completos via RPM Fusion e GStreamer (H.264, HEVC/H.265, AV1, VP8/VP9, AAC, MP3, WebP, SVG, AVIF).
- **📁 Nautilus Completo & Descompactação Ultra-Rápida:**
  - Miniaturas/Thumbnails para todos os arquivos (fotos, vetor, WebP, AVIF, PDFs e vídeos).
  - Suporte a extração de arquivos comprimidos (zip, 7z, tar, zstd) com multithreading.
- **📸 Screenshots Nativos com Anotação e Desfoque (Blur):**
  - Integração com **`grim + slurp + satty`** na tecla `Print` (seleção de região, setas, texto, e **blur para ocultar dados sensíveis**).
- **🛡️ Polkit Agent GTK4 Nativo:**
  - Janelas de autenticação de senha de administrador integradas nativamente ao Dank Material Shell em GTK4 / Libadwaita Wayland.
- **🌌 Integração Oficial com Dank Material Shell:**
  - No encerramento da preparação da base do sistema, executa o instalador oficial do DMS (`curl -fsSL https://install.danklinux.com | sh`) para personalização gráfica de compositores e terminal.

---

## 📥 Como Usar

### 1. Pré-requisitos
1. Baixar a ISO **Fedora Everything (Netinstall)** no site oficial.
2. Na instalação do Fedora, escolha a opção **Minimal Install**.

### 2. Executar o Script
Após o primeiro boot no terminal:

```bash
# Clone este repositório:
git clone https://github.com/danieldemoura/fedora-shell-setup.git
cd fedora-shell-setup

# Dê permissão e execute:
chmod +x setup.sh
./setup.sh
```

---

## 📦 Lista Completa de Pacotes Instalados

| Categoria | Pacote | Função / Descrição |
| :--- | :--- | :--- |
| **GPU & Híbrido** | `switcheroo-control` | Daemon D-Bus para alternância dinâmica entre GPU integrada (Intel/AMD) e dedicada (NVIDIA) |
| | `akmod-nvidia` | Driver proprietário NVIDIA com recompilação automática de módulos do kernel |
| | `xorg-x11-drv-nvidia-cuda` | Suporte a CUDA e aceleração gráfica NVIDIA |
| | `nvidia-vaapi-driver` | Aceleração por hardware VA-API para placas NVIDIA no Wayland |
| | `intel-media-driver` | Driver VA-API para aceleração de vídeo em GPUs Intel |
| | `mesa-va-drivers` | Driver VA-API para aceleração de vídeo em GPUs AMD Radeon |
| **Energia & Notebook**| `power-profiles-daemon`| Gerenciador de perfis de energia (Economia, Balanceado, Desempenho) |
| | `upower` | Daemon de abstração para gerenciamento de bateria |
| | `brightnessctl` | Utilitário para ajuste do brilho da tela nas teclas FN |
| | `playerctl` | Controle de reprodução de áudio e vídeo nas teclas FN |
| **Áudio & Conectividade** | `pipewire` / `wireplumber` | Servidor multimídia Wayland de baixa latência e gerenciador de rotas |
| | `pipewire-alsa` / `pulse` / `jack` | Pontes de compatibilidade de áudio |
| | `pwvucontrol` | Interface GTK4 para controle avançado de volume |
| | `bluez` / `blueman` | Pilha Bluetooth oficial e gerenciador gráfico de pareamento |
| | `NetworkManager` / `wifi` | Gerenciador de conexões de rede e redes sem fio |
| | `cups` / `simple-scan` | Sistema de impressão e ferramenta de digitalização de documentos |
| **Codecs Mídia** | `ffmpeg` | Suíte multimídia completa do RPM Fusion |
| | `@multimedia` / `gstreamer1-plugins` | Plugins para H.264, HEVC/H.265, AV1, VP8/VP9, openh264, MP3, AAC, FLAC |
| **Nautilus & Arquivos** | `nautilus` / `gvfs` / `udisks2` | Gerenciador de arquivos, montagem automática MTP/USB/SMB |
| | `glycin-thumbnailer` / `ffmpegthumbnailer` | Miniaturas de fotos, imagens vetor, WebP, AVIF e vídeos |
| | `file-roller` / `p7zip` / `zstd` / `unzip` | Extração ultra-rápida de arquivos comprimidos |
| **Visual & Screenshots**| `grim` / `slurp` / `satty` | Captura de tela com anotação (setas, textos) e **desfoque/blur de dados sensíveis** |
| | `google-noto-fonts` / `jetbrains-mono-nerd-font` | Fontes completas, Emojis em HD e ícones para o terminal/shell |
| | `greetd` / `tuigreet` | Display Manager para login gráfico com senha |

---

## 📋 Documentação Técnica

Veja o plano detalhado de implementação consolidado em [`docs/plano_de_implementacao.md`](docs/plano_de_implementacao.md).
