# Plano de Implementação Final — Fedora Minimal Base + Dank Material Shell (Universal Hardware)

> **Objetivo:** Criar um script de instalação base universal, limpo, ultra-rápido e robusto para **Fedora Minimal Install**, compatível com qualquer computador (Desktop ou Notebook, Intel/AMD/NVIDIA). O script prepara 100% dos subsistemas de hardware, codecs de áudio/vídeo universais, Nautilus completo com todas as miniaturas e suporte a arquivos, screenshot profissional com anotação (`grim + slurp + satty`), Polkit Agent GTK4 nativo em Wayland e, no final, encadeia a execução do instalador oficial do **Dank Material Shell** (`curl -fsSL https://install.danklinux.com | sh`) para personalização do ambiente Wayland (Niri / Hyprland).

---

## 🎯 Decisões Consolidadas do Projeto

| Item | Decisão Final |
| :--- | :--- |
| **ISO Base** | Fedora Everything (Netinstall) — Escolher **Minimal Install** |
| **Compatibilidade de Hardware** | **Universal** (Notebooks e Desktops; Intel, AMD e NVIDIA). Detecção automática via `lspci` para GPU e chassis type (`/sys/class/dmi/id/chassis_type`). |
| **Login e Autenticação** | **Sem Auto-login**. Tela de login gráfica via `greetd` habilitada. |
| **Aplicativos de Dev / Pessoais** | **REMOVIDOS**. O script **NÃO** instalará VS Code, Git, FNM, Node.js, Podman, Brave, Discord, etc. O sistema fica 100% limpo para o usuário instalar o que quiser após o boot. |
| **Gestão de Bateria & Energia** | **Adaptativa**. Se for Notebook: ativa `power-profiles-daemon` + `upower` + `brightnessctl`. Se for Desktop: otimizações de desempenho sem limitação de bateria. |
| **Screenshots & Anotações** | **`grim + slurp + satty`** (Wayland GTK4). Ao pressionar `Print`, abre seleção de área, permite desenhar setas, escrever textos, aplicar **blur/desfoque em dados sensíveis**, copiar para o clipboard ou salvar em arquivo. |
| **Polkit Agent (Senha Sudo)** | **Polkit Agent GTK4 Nativo** (integrado ao Dank Material Shell em Wayland com suporte a temas de cores dinâmicos). |
| **Codecs de Mídia** | **100% Completos**. Instalação de todos os codecs conhecidos (H.264, H.265/HEVC, AV1, VP8/VP9, AAC, MP3, FLAC, Opus, MP4, WebP, AVIF, SVG, etc.) via RPM Fusion e GStreamer. |
| **Gerenciador de Arquivos (Nautilus)** | **Recursos Máximos** (Thumbnailer total para fotos, vídeos, vector, PDF, gifs + `file-roller` com suporte a `p7zip`, `unzip`, `zstd` para extração ultra-rápida de qualquer arquivo comprimido). |
| **Interface & Encadeamento Final** | O script instala toda a base do sistema, repositórios, drivers, áudio, bluetooth, fontes e dependências e **no final chama o script oficial do Dank Material Shell** (`curl -fsSL https://install.danklinux.com | sh`), onde o usuário escolhe Niri ou Hyprland de forma oficial e interativa. |

---

## 🏗️ Arquitetura e Fluxo do Script (`setup.sh`)

```
setup.sh (Executado no Fedora Minimal)
  │
  ├── [ETAPA 0] Verificação Inicial (Sudo, Internet, Distribuição Fedora)
  ├── [ETAPA 1] Detecção Inteligente de Hardware:
  │             ├── CPU (Intel vs AMD)
  │             ├── GPU (NVIDIA vs AMD vs Intel Integrated)
  │             └── Form Factor (Notebook vs Desktop)
  │
  ├── [ETAPA 2] Atualização & Repositórios Básicos:
  │             ├── dnf upgrade --refresh
  │             ├── RPM Fusion (Free e Nonfree)
  │             ├── Flathub (Flatpak base)
  │             └── Copr Repositories (DMS / Niri / Satty)
  │
  ├── [ETAPA 3] Subsistema Áudio & Conectividade (Estilo Ubuntu/Mint):
  │             ├── Áudio: PipeWire, WirePlumber, pipewire-alsa, pipewire-pulseaudio, pwvucontrol
  │             ├── Bluetooth: Bluez, bluez-tools, Blueman
  │             └── Rede: NetworkManager, NetworkManager-wifi, iw, nm-connection-editor
  │
  ├── [ETAPA 4] Drivers Gráficos & Gerenciamento de Energia:
  │             ├── NVIDIA: akmod-nvidia, xorg-x11-drv-nvidia-cuda, nvidia-vaapi-driver (se GPU NVIDIA)
  │             ├── Intel/AMD: Mesa-va-drivers, intel-media-driver
  │             ├── GPU Híbrida: switcheroo-control
  │             └── Bateria/Notebook: power-profiles-daemon, upower, brightnessctl (se Laptop)
  │
  ├── [ETAPA 5] Codecs Multimídia 100% Completos:
  │             ├── Swap ffmpeg-free por ffmpeg (RPM Fusion)
  │             ├── @multimedia, gstreamer1-plugins-bad-free/freeworld, gstreamer1-plugins-ugly
  │             └── openh264, libavcodec, x264, x265, dav1d (AV1), ffmpeg-libs
  │
  ├── [ETAPA 6] Nautilus Completo & Suporte Total a Arquivos:
  │             ├── Nautilus, udisks2, gvfs (gvfs-mtp, gvfs-smb, gvfs-archive, gvfs-fuse)
  │             ├── Miniaturas: glycin-thumbnailer, ffmpegthumbnailer, webp-pixbuf-loader,
  │             │   librsvg2, evince-thumbnailer, gdk-pixbuf2, qt5-qtimageformats, qt6-qtimageformats
  │             └── Compactadores Ultra-Rápidos: file-roller, p7zip, p7zip-plugins, unzip, tar, xz, zstd, unrar
  │
  ├── [ETAPA 7] Utilitários de Sistema, Fontes, Screenshot e Polkit GTK4:
  │             ├── Screenshot com Anotação: grim, slurp, satty, wl-clipboard
  │             ├── Fontes: Google Noto Fonts (Emoji completo), JetBrains Mono Nerd Font, Adwaita Icons
  │             ├── Polkit Agent: Nativo GTK4 integrado ao Dank Material Shell
  │             └── Greeter: greetd + suporte a sessões Wayland (sem auto-login)
  │
  ├── [ETAPA 8] Habilitação de Daemons & Serviços de Sistema:
  │             └── systemctl enable NetworkManager bluetooth greetd power-profiles-daemon switcheroo-control cups avahi-daemon
  │
  └── [ETAPA 9] Encadeamento Final com Dank Material Shell:
                ├── Pergunta se deseja iniciar o instalador oficial do Dank Material Shell agora.
                └── Executa: curl -fsSL https://install.danklinux.com | sh
```

---

## 📂 Organização de Arquivos no Repositório

- `setup.sh` — Script principal limpo, modular e comentado.
- `README.md` — Documentação completa e atualizada do projeto.
- `configs/satty.toml` — Configuração para a ferramenta de captura de tela `satty` (atalhos de anotação, cores, desfoque/blur).
- `configs/greetd-config.toml` — Configuração de login gráfico.
- `docs/plano_de_implementacao.md` — Plano final consolidado único.
