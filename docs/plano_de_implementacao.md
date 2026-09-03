# Plano de Implementação — FedoraShell Setup Script

> Versão 2.0 — Atualizado com todas as respostas do usuário

---

## Contexto

Criar um script Bash interativo com visual estilizado (inspirado no Dank Material Shell installer),
que configura um Fedora mínimo com compositor Wayland (Niri ou Hyprland), desktop shell
(Noctalia ou Dank Material Shell), drivers, codecs e aplicativos escolhidos pelo usuário.

**Hardware alvo:** Lenovo Legion Slim 5i — Intel i5-13420H + NVIDIA RTX 3050 (Optimus) + 16GB RAM

---

## Decisões Confirmadas

| Decisão | Resposta |
|---------|----------|
| ISO base | Fedora Everything (netinstall) — Minimal Install |
| Secure Boot | Só aviso no script, sem instruções |
| Áudio | `pwvucontrol` (Flatpak — GTK4, nativo Wayland) |
| App launcher | Fuzzel (apenas se instalar compositor sem shell) |
| Barra de status | Gerenciada automaticamente pelo shell escolhido |
| Navegadores | Firefox + Brave (ambos na lista, pré-selecionados) |
| Node.js | nvm (recomendado para dev, permite trocar versões) |
| Filosofia de apps | Preferir GTK4 + Wayland sempre que disponível |

---

## Arquitetura do Script

```
setup.sh
├── [ETAPA 0]  Verificação do Sistema
├── [ETAPA 1]  Atualização do Sistema
├── [ETAPA 2]  Repositórios (RPM Fusion, Flathub, COPRs)
├── [ETAPA 3]  Base Wayland (deps obrigatórias)
├── [ETAPA 4]  Escolha do Compositor (Niri / Hyprland / Nenhum dos dois)
├── [ETAPA 5]  Escolha do Desktop Shell (Noctalia / DMS / Nenhum)
├── [ETAPA 6]  Tela de Login (greetd + greeter correto para o shell)
├── [ETAPA 7]  Drivers (NVIDIA opcional, Intel automático, codecs)
├── [ETAPA 8]  Hardware (impressoras, Bluetooth, Wi-Fi, scanner)
├── [ETAPA 9]  Seleção de Aplicativos (menu com grupos e checkboxes)
├── [ETAPA 10] Utilitários essenciais do sistema
├── [ETAPA 11] Habilitação dos Serviços
└── [ETAPA 12] Resumo + Reinicialização
```

---

## Organização do Código

O script terá uma seção de configuração global no topo. Para adicionar/remover um app,
o usuário apenas edita esse bloco, sem precisar caçar nada pelo código.

```bash
# ================================================
# CONFIGURAÇÃO GLOBAL DE APLICATIVOS
# Para adicionar, remover ou editar apps: edite AQUI.
# ================================================

# Formato: "nome_interno|nome_exibido|método|id_pacote|obrigatorio|pré-selecionado|grupo"
# método: dnf | flatpak | rpm_repo | nvm

APP_LIST=(
  # -- Grupo: Navegadores --
  "firefox|Firefox|flatpak|org.mozilla.firefox|false|true|Navegadores"
  "brave|Brave|rpm_repo|brave-browser|false|true|Navegadores"

  # -- Grupo: Terminal e Sistema --
  "kitty|Kitty Terminal|dnf|kitty|true|true|Terminal"
  "fastfetch|Fastfetch|dnf|fastfetch|false|true|Terminal"

  # -- Grupo: Apps GNOME --
  "nautilus|Gerenciador de Arquivos|dnf|nautilus|false|true|GNOME"
  "calculator|Calculadora|flatpak|org.gnome.Calculator|false|true|GNOME"
  "loupe|Visualizador de Imagens|flatpak|org.gnome.Loupe|false|true|GNOME"
  "evince|Leitor de PDF|flatpak|org.gnome.Evince|false|true|GNOME"
  "disks|Gerenciador de Discos|flatpak|org.gnome.DiskUtility|false|true|GNOME"
  "baobab|Analisador de Uso de Disco|flatpak|org.gnome.baobab|false|false|GNOME"
  "characters|Tabela de Caracteres|flatpak|org.gnome.Characters|false|false|GNOME"

  # -- Grupo: Multimídia --
  "mpcqt|MPC-QT|flatpak|io.github.mpc_qt.mpc-qt|false|true|Multimídia"
  "pwvucontrol|Controle de Áudio|flatpak|io.github.saivert.pwvucontrol|false|true|Multimídia"

  # -- Grupo: Utilitários --
  "warehouse|Warehouse|flatpak|io.github.flattool.Warehouse|false|true|Utilitários"
  "devtoolbox|Dev Toolbox|flatpak|me.iepure.devtoolbox|false|false|Utilitários"

  # -- Grupo: Desenvolvimento --
  "vscode|VSCode|rpm_repo|code|false|true|Desenvolvimento"
  "git|Git|dnf|git|false|true|Desenvolvimento"
  "nodejs|Node.js (via nvm)|nvm|nvm|false|true|Desenvolvimento"
  "distrobox|Distrobox|dnf|distrobox|false|false|Desenvolvimento"
)
```

---

## Detalhamento das Etapas

### Etapa 0 — Verificação do Sistema

- Verificar se está rodando como usuário normal (não root) com sudo disponível
- Verificar conexão com a internet (`ping -c1 8.8.8.8`)
- Verificar se é Fedora (`/etc/fedora-release`)
- Detectar GPU automaticamente com `lspci | grep -i nvidia`
- Se encontrar NVIDIA → exibir aviso sobre Secure Boot

### Etapa 1 — Atualização

```bash
sudo dnf upgrade --refresh -y
```

### Etapa 2 — Repositórios (ordem importantíssima)

1. RPM Fusion Free + Nonfree
2. Flathub (sem isso o Warehouse e outros Flatpaks falham)
3. COPRs necessários conforme escolha do compositor/shell

### Etapa 3 — Base Wayland

Instalados automaticamente, sem perguntar ao usuário:

```
wayland wayland-utils wl-clipboard wl-color-picker
xdg-utils xdg-user-dirs xdg-desktop-portal xdg-desktop-portal-gtk
pipewire pipewire-alsa pipewire-pulseaudio pipewire-jack wireplumber
pipewire-gstreamer                        ← para screen sharing funcionar
NetworkManager NetworkManager-wifi
polkit polkit-gnome
dbus-daemon dbus-broker
accountsservice
udisks2                                   ← para montar dispositivos no Nautilus
gvfs gvfs-mtp gvfs-smb gvfs-fuse gvfs-archive  ← integrações do Nautilus
```

### Etapa 4 — Compositor (menu interativo)

| Opção | Pacotes instalados | Portal de tela |
|-------|-------------------|----------------|
| **Niri** | `niri` (dnf) | `xdg-desktop-portal-gnome` + config `portals.conf` |
| **Hyprland** | COPR `solopasha/hyprland` → `hyprland hyprctl hyprpaper hypridle hyprlock` | `xdg-desktop-portal-hyprland` + `xdg-desktop-portal-gtk` |
| **Nenhum** | — | — |

### Etapa 5 — Desktop Shell (menu interativo)

| Opção | Pacotes | App launcher |
|-------|---------|-------------|
| **Noctalia** | `noctalia` (dnf oficial Fedora 44+) | **Embutido** — não instala Fuzzel |
| **Dank Material Shell** | COPR `avengemedia/dms` → `dms` | **Embutido** — não instala Fuzzel |
| **Nenhum** | — | Instala `fuzzel` |

### Etapa 6 — Tela de Login

| Shell escolhido | Display Manager | Greeter |
|----------------|----------------|---------|
| Noctalia | `greetd` | `noctalia-greeter` |
| Dank Material Shell | `greetd` | `dms-greeter` |
| Nenhum | `greetd` | `tuigreet` (simples, terminal) |

Script configura automaticamente `/etc/greetd/config.toml` e adiciona permissões ao usuário `greeter`:
```bash
sudo usermod -aG video,input,seat greeter
```

### Etapa 7 — Drivers e Codecs

**NVIDIA (pergunta ao usuário — detectado automaticamente):**
```bash
sudo dnf install akmod-nvidia
sudo akmods --force && sudo dracut --force
# Aviso: aguardar compilação antes de reiniciar
```

**Intel (automático no Legion):**
```bash
sudo dnf install intel-media-driver  # VA-API aceleração de vídeo
```

**Codecs multimídia completos:**
```bash
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf install @multimedia --setopt="install_weak_deps=False" \
                 --exclude=PackageKit-gstreamer-plugin
sudo dnf install gstreamer1-plugin-openh264 mozilla-openh264
```

### Etapa 8 — Hardware

```bash
# Impressoras — qualquer marca, USB ou Wi-Fi
sudo dnf install cups cups-browsed hplip avahi system-config-printer
sudo firewall-cmd --add-service=mdns --permanent
sudo firewall-cmd --add-service=ipp --permanent
sudo firewall-cmd --add-service=ipp-client --permanent
sudo firewall-cmd --reload

# Scanner (bônus — funciona com a maioria das impressoras multifuncionais)
sudo dnf install simple-scan sane-backends

# Bluetooth
sudo dnf install bluez bluez-tools blueman

# Wi-Fi (já funciona no kernel, reforço de utilitários)
sudo dnf install NetworkManager-wifi iw
```

### Etapa 9 — Seleção de Aplicativos

Menu com grupos separados, setas ↑↓, espaço para marcar/desmarcar.
Apps pré-selecionados: Firefox, Brave, Kitty, Fastfetch, Nautilus, Calculadora,
Visualizador de Imagens, Leitor de PDF, Gerenciador de Discos, MPC-QT,
Controle de Áudio, Warehouse, VSCode, Git, Node.js.

**Pacotes extra instalados junto com o Nautilus (automático, sem perguntar):**
```bash
# Miniaturas de imagens (todos os tipos)
glycin-thumbnailer
gdk-pixbuf2
webp-pixbuf-loader          # WebP
librsvg2                    # SVG

# Miniaturas de vídeo
ffmpegthumbnailer

# Abertura de arquivos e integração
file-roller                 # Descompactador
nautilus-extensions
evince-thumbnailer          # PDF preview
```

**Brave:** Instalado via repositório oficial RPM da Brave (não Flatpak — a Brave não recomenda o Flatpak por questões de segurança do sandbox).

**Node.js via nvm:**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
```

**VSCode:** Repositório oficial Microsoft RPM.

### Etapa 10 — Utilitários Essenciais (automáticos)

```bash
# Fontes (sem elas apps GTK ficam feios/quebrados)
sudo dnf install google-noto-fonts-all google-noto-emoji-fonts

# Ícones e temas (apps GTK se integram melhor)
sudo dnf install adwaita-icon-theme hicolor-icon-theme

# Compactadores
sudo dnf install unzip p7zip p7zip-plugins

# Utilitários de terminal
sudo dnf install curl wget nano bash-completion htop

# Locale pt-BR
sudo localectl set-locale LANG=pt_BR.UTF-8
sudo localectl set-keymap br-abnt2
```

### Etapa 11 — Habilitação dos Serviços

```bash
sudo systemctl enable greetd
sudo systemctl enable cups cups-browsed
sudo systemctl enable bluetooth
sudo systemctl enable avahi-daemon
sudo systemctl enable NetworkManager
sudo systemctl set-default graphical.target
```

### Etapa 12 — Resumo + Reinicialização

- Exibe lista estilizada de tudo instalado com status (✓ / ✗)
- Pergunta se quer reiniciar agora ou mais tarde
- Mensagem de boas-vindas final

---

## Visual do Script (TUI)

- **Tecnologia:** Bash puro + códigos ANSI (sem dependências externas)
- **Paleta:** Preto/ciano (igual ao dankinstall)
- **Banner:** ASCII art do nome do script no topo
- **Menus:** Setas ↑↓ para navegar, Enter para confirmar, Espaço para checkboxes
- **Indicadores:** `○ Será instalado`, `✓ Já instalado`, `✗ Pulado`
- **Barras de progresso** durante instalações longas
- **Idioma:** 100% Português do Brasil

---

## Pontos Abertos — Novas Perguntas

Veja o plano revisado para as perguntas pendentes.
