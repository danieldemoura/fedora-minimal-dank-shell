# Plano de Implementação Final — Fedora Minimal Base + Dank Material Shell (Universal Hardware)

> **Objetivo:** Criar um script de instalação base universal, limpo, ultra-rápido e robusto para **Fedora Minimal Install**, compatível com qualquer computador (Desktop ou Notebook, Intel/AMD/NVIDIA). O script prepara 100% dos subsistemas de hardware, GPUs híbridas (`switcheroo-control`), codecs de áudio/vídeo universais, Nautilus completo com todas as miniaturas e suporte a arquivos, screenshot profissional com anotação (`grim + slurp + satty`), Polkit Agent GTK4 nativo em Wayland e, no final, encadeia a execução do instalador oficial do **Dank Material Shell** (`curl -fsSL https://install.danklinux.com | sh`) para personalização do ambiente Wayland (Niri / Hyprland).

---

## 🎯 Decisões Consolidadas do Projeto

| Item | Decisão Final |
| :--- | :--- |
| **ISO Base** | Fedora Everything (Netinstall) — Escolher **Minimal Install** / **Custom Operating System** e marcar **`Common NetworkManager Submodules`** e **`Standard`** para garantir rede no primeiro boot. |
| **Compatibilidade de Hardware** | **Universal** (Notebooks e Desktops; Intel, AMD e NVIDIA). Detecção automática via `lspci` para GPU e chassis type (`/sys/class/dmi/id/chassis_type`). |
| **GPU Híbrida (Dual GPU)** | Configuração e ativação automática do **`switcheroo-control`** para alternância dinâmica D-Bus entre GPU integrada (Intel/AMD) e dedicada (NVIDIA). |
| **Login e Autenticação** | **Sem Auto-login**. Tela de login gráfica via `greetd` + `tuigreet` habilitada. |
| **Navegador Web Padrão** | **Brave Browser** (instalado via Flathub) para garantir navegação segura com bloqueio de anúncios out-of-the-box. |
| **Aplicativos de Dev / Pessoais** | **LIMPO**. O script não instalará VS Code, FNM, Node.js, Podman, Discord, etc. O sistema fica limpo para o usuário instalar suas ferramentas de desenvolvimento pessoais no pós-instalação. |
| **Gestão de Bateria & Energia** | **Adaptativa**. Se for Notebook: ativa `power-profiles-daemon` + `upower` + `brightnessctl`. Se for Desktop: otimizações de desempenho sem limitação de bateria. |
| **Screenshots & Anotações** | **`grim + slurp + satty`** (Wayland GTK4). Pressionar `Print` abre seleção de área, permite desenhar setas, escrever textos, aplicar **blur/desfoque em dados sensíveis**, copiar para o clipboard ou salvar em arquivo. |
| **Polkit Agent (Senha Sudo)** | **Polkit Agent GTK4 Nativo** (integrado ao Dank Material Shell em Wayland com suporte a temas de cores dinâmicos). |
| **Codecs de Mídia** | **100% Completos**. Instalação de todos os codecs conhecidos (H.264, H.265/HEVC, AV1, VP8/VP9, AAC, MP3, FLAC, Opus, MP4, WebP, AVIF, SVG, etc.) via RPM Fusion e GStreamer. |
| **Gerenciador de Arquivos (Nautilus)** | **Recursos Máximos** (Thumbnailer total para fotos, vídeos, vector, PDF, gifs + `file-roller` com suporte a `p7zip`, `unzip`, `zstd` para extração ultra-rápida de qualquer arquivo comprimido). |
| **Interface & Encadeamento Final** | O script instala toda a base do sistema, repositórios, drivers, áudio, bluetooth, fontes e dependências e **no final chama o script oficial do Dank Material Shell** (`curl -fsSL https://install.danklinux.com | sh`), onde o usuário escolhe Niri ou Hyprland de forma oficial e interativa. |

---

## 📦 Lista Completa de Pacotes Instalados e Suas Funções

Abaixo está o catálogo detalhado de **todos os pacotes** instalados pelo `setup.sh` no Fedora Minimal, agrupados por subsistema:

### 🎮 1. Drivers, Vídeo & GPU Híbrida
- **`switcheroo-control`**: Daemon D-Bus responsável por permitir a alternância dinâmica entre a GPU integrada (Intel/AMD) e a GPU dedicada (NVIDIA) em sistemas híbridos (dual GPU).
- **`akmod-nvidia`**: Driver proprietário da NVIDIA para kernel Linux com compilação automática durante atualizações do sistema.
- **`xorg-x11-drv-nvidia-cuda`**: Bibliotecas de suporte a CUDA para execução de tarefas de computação e jogos na GPU NVIDIA.
- **`nvidia-vaapi-driver`**: Driver de aceleração por hardware VA-API para placas NVIDIA rodando em sessões Wayland.
- **`intel-media-driver`**: Driver VA-API oficial da Intel para aceleração de vídeo via hardware em GPUs Intel HD/UHD/Iris/Arc.
- **`mesa-va-drivers`**: Drivers de aceleração de vídeo VA-API da suíte Mesa para GPUs AMD Radeon.

### ⚡ 2. Gerenciamento de Energia & Hardware de Notebook
- **`power-profiles-daemon`**: Daemon de controle de perfis de energia (Economia de Bateria, Balanceado e Alta Performance).
- **`upower`**: Abstração de gerenciamento de energia, consumo e status de baterias no Linux.
- **`brightnessctl`**: Utilitário leve para controle do brilho do painel de tela via teclas FN do teclado.
- **`playerctl`**: Utilitário CLI/D-Bus para controle de reprodução de mídia (Play, Pause, Próxima) pelas teclas de atalho FN.

### 🎵 3. Áudio, Rede, Bluetooth e Impressão
- **`pipewire`**: Servidor de som e vídeo de ultra-baixa latência nativo do Wayland moderno.
- **`wireplumber`**: Gerenciador oficial de sessões e rotas de áudio do PipeWire.
- **`pipewire-alsa`**: Ponte de compatibilidade para aplicativos que utilizam a API tradicional ALSA.
- **`pipewire-pulseaudio`**: Emulador do protocolo PulseAudio executado sobre o PipeWire.
- **`pipewire-jack`**: Camada de suporte a softwares de áudio profissional compatíveis com JACK.
- **`pipewire-gstreamer`**: Plugin GStreamer para streaming de áudio e captura de telas/sessões Wayland.
- **`pwvucontrol`**: Controle de volume e dispositivos de áudio gráfico feito em GTK4.
- **`bluez`**: Pilha oficial do protocolo Bluetooth para Linux.
- **`bluez-tools`**: Utilitários de linha de comando para configuração de dispositivos Bluetooth.
- **`blueman`**: Gerenciador gráfico de conexões e pareamento Bluetooth.
- **`NetworkManager`**: Gerenciador principal de conexões de rede do sistema.
- **`NetworkManager-wifi`**: Módulo do NetworkManager para redes sem fio.
- **`iw`**: Ferramenta de configuração de baixo nível para interfaces Wi-Fi.
- **`nm-connection-editor`**: Editor gráfico de conexões e perfis de rede.
- **`cups`**: Daemon oficial do sistema de impressão do Linux (Common UNIX Printing System).
- **`cups-browsed`**: Daemon para busca e adição automática de impressoras na rede local.
- **`cups-pk-helper`**: Helper de autorização Polkit (PolicyKit) para alteração de configurações e adição de impressoras no CUPS por usuários não-root sem depender do terminal.
- **`avahi`**: Serviço de resolução de nomes e descoberta de rede mDNS/DNS-SD (Zeroconf).
- **`sane-backends`**: Conjunto de drivers e suporte a digitalizadores (Scanners).
- **`simple-scan`**: Aplicativo gráfico para digitalização rápida de documentos.

### 🎥 4. Codecs Multimídia Totais
- **`ffmpeg`**: Suíte multimídia completa (versão RPM Fusion sem restrições de patentes) para decodificação e codificação de áudio/vídeo.
- **`@multimedia`**: Meta-pacote do Fedora/RPM Fusion contendo codecs e utilitários essenciais de mídia.
- **`gstreamer1-plugins-bad-freeworld`**: Plugins adicionais do GStreamer para formatos proprietários.
- **`gstreamer1-plugins-ugly`**: Plugins do GStreamer para formatos comerciais e legados.
- **`gstreamer1-plugin-openh264`**: Plugin do GStreamer para o codec de vídeo H.264.
- **`mozilla-openh264`**: Módulo H.264 para navegação na web e streaming de mídia.
- **`libavcodec-freeworld`**: Bibliotecas de decodificação de codecs proprietários de alta eficiência.
- **`x264`**: Biblioteca de codificação de vídeo em formato H.264 / MPEG-4 AVC.
- **`x265`**: Biblioteca de codificação de vídeo em formato HEVC / H.265.
- **`dav1d`**: Decodificador de vídeo no formato AV1 desenvolvido pela comunidade VideoLAN (VLC).
- **`ffmpeg-libs`**: Bibliotecas de runtime do FFmpeg necessárias para reprodutores de mídia.

### 📁 5. Nautilus Completo, Miniaturas e Suporte a Arquivos
- **`nautilus`**: Gerenciador de arquivos oficial da plataforma GTK.
- **`udisks2`**: Serviço de montagem automática e gerenciamento de mídias removíveis (pendrives, HDs externos).
- **`gvfs`**: Sistema de arquivos virtual que permite ao Nautilus conectar a dispositivos MTP (celular), compartilhamentos SMB de rede, ISOs e arquivos compactados.
- **`glycin-thumbnailer`**: Gerador moderno e seguro de miniaturas para formatos de imagem.
- **`ffmpegthumbnailer`**: Gerador ultra-rápido de miniaturas para arquivos de vídeo (MP4, MKV, AVI).
- **`webp-pixbuf-loader`**: Plugin para suporte e geração de miniaturas de imagens WebP no Nautilus.
- **`librsvg2`**: Biblioteca para renderização e miniaturas de arquivos vetoriais SVG.
- **`evince-thumbnailer`**: Gerador de pré-visualizações para documentos PDF.
- **`gdk-pixbuf2`**: Biblioteca base para carregamento e manipulação de formatos de imagem GTK.
- **`qt5-qtimageformats` / `qt6-qtimageformats`**: Suporte para renderização de formatos avançados de imagem em aplicativos Qt (ex: AVIF, HEIC).
- **`kf6-kimageformats` / `kf5-kimageformats`**: Plugins do KDE/Qt Frameworks para carregamento de imagens avançadas (HDR, EXR, HEIF/HEIC, KRA, OpenRaster, PSD) no motor Qt6 do Dank Material Shell.
- **`file-roller`**: Gerenciador gráfico de arquivos compactados e descompactação.
- **`p7zip` / `p7zip-plugins`**: Utilitário multithread de alta compressão para formatos `.7z` e `.zip`.
- **`unzip`**: Ferramenta de extração para arquivos comprimidos `.zip`.
- **`tar`**: Ferramenta clássica de arquivamento no Linux.
- **`xz`**: Compressor de alta taxa de redução de dados.
- **`zstd`**: Algoritmo de compressão e extração ultra-rápido desenvolvido pela Meta.
- **`unrar`**: Extração de arquivos compactados em formato `.rar`.

### 📸 6. Captura de Tela, Fontes, Visual & Display Manager
- **`com.brave.Browser`**: Navegador Web moderno com foco em privacidade e bloqueio automático de anúncios/trackers (instalado via Flathub).
- **`grim`**: Ferramenta nativa de captura de telas do compositor Wayland.
- **`slurp`**: Ferramenta interativa de seleção de área da tela com o mouse no Wayland.
- **`satty`**: Utilitário GTK4 de edição de captura de tela (desenhar, colocar texto, setas, retângulos e **aplicar blur em senhas/dados sensíveis**).
- **`wl-clipboard`**: Ferramenta de integração com a área de transferência do Wayland (`wl-copy` e `wl-paste`).
- **`google-noto-fonts-all`**: Família de fontes universais Noto do Google.
- **`google-noto-emoji-fonts`**: Fonte oficial de Emojis em alta definição.
- **`jetbrains-mono-nerd-font`**: Fonte monoespaçada com ícones integrados (Nerd Fonts) para terminais e barras de status.
- **`adwaita-icon-theme` / `hicolor-icon-theme`**: Temas de ícones padrão do ambiente GTK.
- **`curl` / `wget`**: Ferramentas CLI para transferência de dados via protocolos web.
- **`nano`**: Editor de textos no terminal simples e direto.
- **`bash-completion`**: Preenchimento automático de comandos e argumentos no Bash via tecla Tab.
- **`htop`**: Monitor interativo de recursos (CPU, RAM, Processos).
- **`greetd`**: Daemon gerenciador de login gráfico minimalista.
- **`tuigreet`**: Interface de autenticação de usuário para o `greetd`.

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
  │             ├── NVIDIA: akmod-nvidia, xorg-x11-drv-nvidia-cuda, nvidia-vaapi-driver
  │             ├── Intel/AMD: Mesa-va-drivers, intel-media-driver
  │             ├── GPU Híbrida: switcheroo-control (Intel/AMD + NVIDIA D-Bus switching)
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
