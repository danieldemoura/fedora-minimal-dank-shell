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
- **🖥️ Compatibilidade Universal de Hardware:**
  - Detecção inteligente via `lspci` de placas de vídeo (NVIDIA, AMD ou Intel) e instalação automática dos drivers adequados (ex: `akmod-nvidia` + `nvidia-vaapi-driver` + `switcheroo-control`).
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

## 📋 Documentação Técnica

Veja o plano detalhado de implementação consolidado em [`docs/plano_de_implementacao.md`](docs/plano_de_implementacao.md).
