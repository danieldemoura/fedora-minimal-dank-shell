#!/usr/bin/env bash
# ==============================================================================
#  🚀 FEDORA MINIMAL BASE SETUP SCRIPT — DANK MATERIAL SHELL READY
#  Compatibilidade Universal: Desktop/Notebook (Intel / AMD / NVIDIA)
# ==============================================================================

set -e

# --- PALETA DE CORES (ANSI) ---
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
BOLD="\033[1;37m"
DIM="\033[0;90m"
RESET="\033[0m"

# --- FUNÇÕES DE LOGGING ---
info() {
    echo -e "${CYAN}[INFO]${RESET} ${BOLD}$1${RESET}"
}

success() {
    echo -e "${GREEN}[OK]${RESET} ${BOLD}$1${RESET}"
}

warning() {
    echo -e "${YELLOW}[AVISO]${RESET} ${BOLD}$1${RESET}"
}

error() {
    echo -e "${RED}[ERRO]${RESET} ${BOLD}$1${RESET}"
}

section() {
    echo -e "\n${BLUE}======================================================================${RESET}"
    echo -e "${BLUE}  $1${RESET}"
    echo -e "${BLUE}======================================================================${RESET}\n"
}

# --- BANNER ---
clear
echo -e "${CYAN}"
cat << "EOF"
  _____ _____ ____   ___  ____    _       ____   _    ____  _____ 
 |  ___| ____|  _ \ / _ \|  _ \  / \     | __ ) / \  / ___|| ____|
 | |_  |  _| | | | | | | | |_) |/ _ \    |  _ \/ _ \ \___ \|  _|  
 |  _| | |___| |_| | |_| |  _ </ ___ \   | |_) / ___ \ ___) | |___ 
 |_|   |_____|____/ \___/|_| \_\_/   \_\ |____/_/   \_\____/|_____|
                                                                  
      🚀 Instalação Base Universal para Fedora Minimal Install
EOF
echo -e "${RESET}"
sleep 1

# ==============================================================================
# ETAPA 0: CHECAGENS INICIAIS
# ==============================================================================
section "ETAPA 0: Verificação Inicial do Sistema"

# 1. Não executar como root diretamente
if [ "$EUID" -eq 0 ]; then
    error "Não execute este script diretamente como root (sudo ./setup.sh)."
    error "Execute como seu usuário normal: ./setup.sh (o sudo será solicitado quando necessário)."
    exit 1
fi

# 2. Verificar conexão com a internet
info "Verificando conexão com a internet..."
if ! ping -c 1 8.8.8.8 >/dev/null 2>&1 && ! ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    error "Sem conexão com a internet. Verifique sua rede e tente novamente."
    exit 1
fi
success "Conexão com a internet confirmada!"

# 3. Verificar se é Fedora
if [ ! -f /etc/fedora-release ]; then
    error "Este script foi projetado especificamente para a distribuição Fedora."
    exit 1
fi
FEDORA_VERSION=$(rpm -E %fedora)
success "Fedora $FEDORA_VERSION detectado!"

# Garantir permissão de sudo
sudo -v

# Keep-alive sudo em segundo plano durante a instalação
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ==============================================================================
# ETAPA 1: DETECÇÃO INTELIGENTE DE HARDWARE
# ==============================================================================
section "ETAPA 1: Detecção Inteligente de Hardware"

HAS_NVIDIA=false
HAS_AMD_GPU=false
HAS_INTEL_GPU=false
IS_LAPTOP=false

# Detecção de GPU
GPU_INFO=$(lspci 2>/dev/null | grep -iE 'vga|3d|display' || true)

if echo "$GPU_INFO" | grep -iq "nvidia"; then
    HAS_NVIDIA=true
    info "GPU Detectada: NVIDIA"
fi

if echo "$GPU_INFO" | grep -iqE "amd|radeon"; then
    HAS_AMD_GPU=true
    info "GPU Detectada: AMD"
fi

if echo "$GPU_INFO" | grep -iq "intel"; then
    HAS_INTEL_GPU=true
    info "GPU Detectada: Intel"
fi

# Detecção de Form Factor (Notebook vs Desktop)
CHASSIS_TYPE=""
if [ -f /sys/class/dmi/id/chassis_type ]; then
    CHASSIS_TYPE=$(cat /sys/class/dmi/id/chassis_type)
fi

# Tipos DMI de Notebook: 8 (Portable), 9 (Laptop), 10 (Notebook), 11 (Hand Held), 14 (Sub Notebook), 30-32
case "$CHASSIS_TYPE" in
    8|9|10|11|14|30|31|32)
        IS_LAPTOP=true
        info "Dispositivo detectado: Notebook / Laptop"
        ;;
    *)
        if [ -d /sys/class/power_supply ] && ls /sys/class/power_supply/BAT* >/dev/null 2>&1; then
            IS_LAPTOP=true
            info "Dispositivo detectado: Notebook / Laptop (bateria encontrada)"
        else
            info "Dispositivo detectado: Computador Desktop / Estação de Trabalho"
        fi
        ;;
esac

# ==============================================================================
# ETAPA 2: REPOSITÓRIOS BASE (RPM FUSION & FLATHUB)
# ==============================================================================
section "ETAPA 2: Configuração de Repositórios (RPM Fusion, Flathub & COPRs)"

info "Atualizando os repositórios existentes do DNF..."
sudo dnf upgrade --refresh -y

info "Instalando repositórios RPM Fusion (Free e Nonfree)..."
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm || true

info "Garantindo utilitários de repositório (dnf-plugins-core e flatpak)..."
sudo dnf install -y dnf-plugins-core flatpak

info "Configurando o repositório Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

info "Habilitando repositórios COPR necessários (DMS)..."
sudo dnf copr enable -y avengemedia/dms 2>/dev/null || true
sudo dnf copr enable -y solopasha/hyprland 2>/dev/null || true

success "Repositórios configurados com sucesso!"

# ==============================================================================
# ETAPA 3: SUBSISTEMAS ÁUDIO, REDE E BLUETOOTH (ESTILO UBUNTU/MINT)
# ==============================================================================
section "ETAPA 3: Subsistemas de Áudio, Rede, Bluetooth e Impressão"

info "Instalando PipeWire (Áudio nativo de baixa latência e controle)..."
sudo dnf install -y --skip-unavailable \
  pipewire \
  pipewire-alsa \
  pipewire-pulseaudio \
  pipewire-gstreamer \
  wireplumber \
  pavucontrol

info "Instalando pwvucontrol (Controle de Áudio GTK4 via Flatpak)..."
sudo flatpak install -y flathub io.github.saivert.pwvucontrol 2>/dev/null || true

info "Instalando Bluetooth e gerenciador gráfico..."
sudo dnf install -y --skip-unavailable \
  bluez \
  bluez-tools \
  blueman

info "Instalando ferramentas de Rede e Wi-Fi..."
sudo dnf install -y --skip-unavailable \
  NetworkManager \
  NetworkManager-wifi \
  iw \
  nm-connection-editor

info "Instalando suporte a Impressoras e Scanner..."
sudo dnf install -y --skip-unavailable \
  cups \
  cups-browsed \
  cups-pk-helper \
  avahi \
  sane-backends \
  simple-scan

success "Subsistemas de áudio, rede, bluetooth e impressão instalados!"

# ==============================================================================
# ETAPA 4: DRIVERS GRÁFICOS & ENERGIA
# ==============================================================================
section "ETAPA 4: Drivers de Vídeo e Gerenciamento Adaptativo de Energia"

# Drivers NVIDIA
if [ "$HAS_NVIDIA" = true ]; then
    info "Instalando drivers NVIDIA proprietários e aceleração VA-API..."
    sudo dnf install -y --skip-unavailable akmod-nvidia xorg-x11-drv-nvidia-cuda nvidia-vaapi-driver switcheroo-control
    warning "NVIDIA akmods recompilará os módulos de kernel em segundo plano."
fi

# Drivers Intel / AMD
if [ "$HAS_INTEL_GPU" = true ]; then
    info "Instalando aceleração de vídeo hardware Intel (VA-API)..."
    sudo dnf install -y --skip-unavailable intel-media-driver switcheroo-control
fi

if [ "$HAS_AMD_GPU" = true ]; then
    info "Instalando suporte de aceleração Mesa para GPU AMD..."
    sudo dnf install -y --skip-unavailable mesa-va-drivers switcheroo-control
fi

# Suporte a GPU Híbrida (Switcheroo Control)
if [ "$HAS_NVIDIA" = true ] || [ "$HAS_INTEL_GPU" = true ] || [ "$HAS_AMD_GPU" = true ]; then
    info "Configurando o switcheroo-control para alternância dinâmica de GPU Híbrida (Intel/AMD + NVIDIA)..."
    sudo dnf install -y --skip-unavailable switcheroo-control
fi

# Recursos de Notebook (Energia e teclas FN)
if [ "$IS_LAPTOP" = true ]; then
    info "Instalando gerenciadores de energia para Notebook (Bateria vs Desempenho)..."
    sudo dnf install -y --skip-unavailable \
      power-profiles-daemon \
      upower \
      brightnessctl \
      playerctl
else
    info "Instalando utilitário de controle de mídia nas teclas de atalho..."
    sudo dnf install -y --skip-unavailable playerctl
fi

success "Drivers e gerenciamento de energia configurados!"

# ==============================================================================
# ETAPA 5: CODECS MULTIMÍDIA 100% COMPLETOS
# ==============================================================================
section "ETAPA 5: Codecs Multimídia Totais (Áudio e Vídeo)"

info "Substituindo ffmpeg-free pela versão completa com todos os patentes ativados..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing || true

info "Instalando suíte multimídia completa do RPM Fusion..."
sudo dnf install -y --skip-unavailable @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin || true

info "Instalando plugins de áudio e vídeo adicionais (H.264, HEVC/H.265, AV1, VP8/VP9, openh264)..."
sudo dnf install -y --skip-unavailable \
  gstreamer1-plugins-bad-freeworld \
  gstreamer1-plugins-ugly \
  gstreamer1-plugin-openh264 \
  mozilla-openh264 \
  libavcodec-freeworld \
  x264 \
  x265 \
  dav1d \
  ffmpeg-libs

success "Codecs de mídia instalados!"

# ==============================================================================
# ETAPA 6: NAUTILUS COMPLETO & MINIATURAS/COMPACTADORES
# ==============================================================================
section "ETAPA 6: Nautilus Completo, Miniaturas e Extração Ultra-Rápida de Arquivos"

info "Instalando Nautilus e integrações de montagem (USB, MTP, SMB)..."
sudo dnf install -y --skip-unavailable \
  nautilus \
  udisks2 \
  gvfs \
  gvfs-mtp \
  gvfs-smb \
  gvfs-archive \
  gvfs-fuse

info "Instalando geradores de miniaturas (Thumbnails) para fotos, vetores, GIFs e vídeos..."
sudo dnf install -y --skip-unavailable \
  glycin-thumbnailer \
  ffmpegthumbnailer \
  webp-pixbuf-loader \
  librsvg2 \
  evince-thumbnailer \
  gdk-pixbuf2 \
  qt5-qtimageformats \
  qt6-qtimageformats \
  kf6-kimageformats \
  kf5-kimageformats

info "Instalando extração e compactação ultra-rápida de arquivos (zip, 7z, tar, zstd, unrar)..."
sudo dnf install -y --skip-unavailable \
  file-roller \
  p7zip \
  p7zip-plugins \
  unzip \
  tar \
  xz \
  zstd \
  unrar

success "Nautilus totalmente equipado com miniaturas e suporte a arquivos!"

# ==============================================================================
# ETAPA 7: SCREENSHOT (SATTY), FONTES & POLKIT GTK4
# ==============================================================================
section "ETAPA 7: Ferramenta de Screenshot (Satty), Fontes Nerd e Display Manager"

info "Instalando captura de tela com anotação e borrão (grim + slurp + satty)..."
sudo dnf install -y --skip-unavailable \
  grim \
  slurp \
  satty \
  wl-clipboard

info "Instalando Fontes do Sistema e Ícones (Noto, Emoji, Nerd Fonts)..."
sudo dnf install -y --skip-unavailable \
  google-noto-fonts-all \
  google-noto-emoji-fonts \
  jetbrains-mono-nerd-font \
  adwaita-icon-theme \
  hicolor-icon-theme

info "Instalando utilitários essenciais de terminal..."
sudo dnf install -y --skip-unavailable \
  curl \
  wget \
  nano \
  bash-completion \
  htop

info "Instalando Display Manager (greetd) para login gráfico com senha..."
sudo dnf install -y --skip-unavailable greetd tuigreet

success "Ferramentas visuais e fontes instaladas!"

# ==============================================================================
# ETAPA 8: APLICAÇÃO DE CONFIGURAÇÕES (DOTFILES)
# ==============================================================================
section "ETAPA 8: Aplicando Configurações do Sistema e Dotfiles"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuração do Satty (Screenshot)
info "Configurando o Satty para captura de tela..."
mkdir -p "$HOME/.config/satty"
if [ -f "$SCRIPT_DIR/configs/satty.toml" ]; then
    cp "$SCRIPT_DIR/configs/satty.toml" "$HOME/.config/satty/config.toml"
    success "Configuração do Satty copiada para ~/.config/satty/config.toml"
fi

# Configuração do XDG Desktop Portal
info "Configurando portais Wayland para compartilhamento de tela..."
sudo mkdir -p /etc/xdg/xdg-desktop-portal
if [ -f "$SCRIPT_DIR/configs/portals.conf" ]; then
    sudo cp "$SCRIPT_DIR/configs/portals.conf" /etc/xdg/xdg-desktop-portal/portals.conf
    success "Configuração de Portais copiada para /etc/xdg/xdg-desktop-portal/portals.conf"
fi

# Configuração do Greetd (Tela de Login)
info "Configurando o Greetd para login gráfico com senha..."
if [ -f "$SCRIPT_DIR/configs/greetd-config.toml" ]; then
    sudo cp "$SCRIPT_DIR/configs/greetd-config.toml" /etc/greetd/config.toml
    sudo usermod -aG video,input,seat greeter 2>/dev/null || true
    success "Greetd configurado com sucesso!"
fi

# Configuração do Idioma e Teclado
info "Definindo locale pt_BR.UTF-8 e teclado ABNT2..."
sudo localectl set-locale LANG=pt_BR.UTF-8 || true
sudo localectl set-keymap br-abnt2 || true

# ==============================================================================
# ETAPA 9: HABILITAÇÃO DOS SERVIÇOS DO SISTEMA
# ==============================================================================
section "ETAPA 9: Habilitando Daemons e Alvo Gráfico"

info "Ativando serviços do systemd..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable greetd
sudo systemctl enable cups
sudo systemctl enable avahi-daemon

if [ "$IS_LAPTOP" = true ]; then
    sudo systemctl enable power-profiles-daemon || true
fi

if [ "$HAS_NVIDIA" = true ] || [ "$HAS_INTEL_GPU" = true ] || [ "$HAS_AMD_GPU" = true ]; then
    sudo systemctl enable switcheroo-control || true
fi

sudo systemctl set-default graphical.target

success "Todos os serviços foram habilitados com sucesso!"

# ==============================================================================
# ETAPA 10: CONCLUSÃO E ENCADEAMENTO DANK MATERIAL SHELL
# ==============================================================================
section "ETAPA 10: Conclusão da Base do Sistema"

echo -e "${GREEN}"
cat << "EOF"
  ______ _____ _     ___ ____ _______  _    ____  _____ ____  !
 |  _  \  ___| |   |_ _|  _ \_ _/ ___|/ \  |  _ \| ____/ ___| !
 | | | | |_  | |    | || |_) | | |   / _ \ | |_) |  _| \___ \ !
 | |_| |  _| | |___ | ||  __/| | |__/ ___ \|  _ <| |___ ___) |!
 |____/|_|   |_____|___|_|  |___\____/_/   \_\_| \_\_____|____/ !
EOF
echo -e "${RESET}"

success "A base mínima e totalmente funcional do Fedora foi instalada!"
info "Tudo o que é essencial para o funcionamento do sistema (áudio, rede, bluetooth,"
info "codecs multimídia, miniaturas do Nautilus, screenshot com borrão e suporte a hardware)"
info "está pronto para uso!"

echo -e "\n${YELLOW}----------------------------------------------------------------------${RESET}"
echo -e "${BOLD}Agora é hora de instalar a interface gráfica e o compositor (Niri / Hyprland)${RESET}"
echo -e "${BOLD}usando o instalador oficial do Dank Material Shell (DMS).${RESET}"
echo -e "${YELLOW}----------------------------------------------------------------------${RESET}\n"

read -p "Deseja executar o instalador oficial do Dank Material Shell agora? (S/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]] || [[ -z $REPLY ]]; then
    info "Iniciando o instalador oficial do Dank Material Shell..."
    curl -fsSL https://install.danklinux.com | sh
else
    info "Você pode executar o instalador do DMS mais tarde executando:"
    echo -e "${CYAN}curl -fsSL https://install.danklinux.com | sh${RESET}\n"
fi

success "Instalação da base finalizada com sucesso! Reinicie o seu sistema para aplicar todas as alterações."
