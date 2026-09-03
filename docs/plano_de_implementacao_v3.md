# Plano de Implementação — FedoraShell Setup Script

> Versão 3.1 — Plano final consolidado com todas as decisões confirmadas, hardware Legion Slim 5i, NiriMod, Screenshot e Dotfiles prontos.

---

## Contexto

Criar um script Bash interativo com visual estilizado (inspirado no Dank Material Shell installer),
que configura um Fedora mínimo com compositor Wayland (Niri ou Hyprland), desktop shell
(Noctalia ou Dank Material Shell), drivers, codecs e aplicativos escolhidos pelo usuário.
O sistema já sai 100% configurado com dotfiles funcionais (atalhos de teclado, autostarts, greeter e temas).

**Hardware alvo:** Lenovo Legion Slim 5i — Intel i5-13420H + NVIDIA RTX 3050 (Optimus) + 16GB RAM

---

## Todas as Decisões Confirmadas

| Decisão              | Escolha final                                                                                 |
| -------------------- | --------------------------------------------------------------------------------------------- |
| ISO base             | Fedora Everything (netinstall) — Minimal Install                                              |
| Secure Boot          | Só aviso no script, sem instruções                                                            |
| Filosofia            | GTK4 + Wayland primeiro, X11 só como fallback                                                 |
| Áudio                | `pwvucontrol` (Flatpak — GTK4, nativo Wayland)                                                |
| Node.js              | **FNM** (Fast Node Manager com hook no `~/.bashrc`)                                           |
| Containers           | **Podman** pré-selecionado, Docker opcional                                                   |
| App launcher         | Integrado ao Shell (DMS/Noctalia); `fuzzel` se compositor puro                                |
| Barra de status      | Gerenciada pelo shell escolhido                                                               |
| Navegadores          | **Brave** (RPM repo oficial) pré-selecionado, Firefox opcional                                |
| Screen sharing       | `xwaylandvideobridge` + `pipewire-gstreamer` + portais                                        |
| Screenshot           | **Dinâmico:** Niri $\rightarrow$ `niri-shot` \| Hyprland $\rightarrow$ `grim + slurp + satty` |
| Configurador Niri    | **NiriMod** (instalado automaticamente junto com o Niri)                                      |
| Teclas FN / Laptop   | `brightnessctl` (brilho) + `playerctl` (mídia) + `wpctl` (áudio)                              |
| GPU Híbrida          | `switcheroo-control` ativado para gerenciar Intel + RTX 3050                                  |
| Dotfiles             | Gerados prontos com autostart do shell, polkit e atalhos de hardware                          |
| WhatsApp             | ZapZap (Flatpak)                                                                              |
| Tipo de app na lista | Exibir o tipo (Flatpak, RPM, Script) para cada app                                            |

---

## Novos Componentes Integrados

### 🎨 NiriMod (Configurador Gráfico para Niri)

- **O que é:** Interface gráfica nativa moderna em GTK4 / Libadwaita feita especificamente para o Niri.
- **Pra que serve:** Permite customizar visualmente todas as opções do Niri (gaps, cantos arredondados, bordas, sombras, animações de scroll infinito, keybindings e regras de janelas) sem necessidade de alterar o arquivo textual `config.kdl` manualmente.

---

## Lista Final de Aplicativos

### 🌐 Navegadores

| App     | Tipo                     | Pré-selecionado |
| ------- | ------------------------ | --------------- |
| Brave   | RPM (repo oficial Brave) | ✅ Sim          |
| Firefox | Flatpak                  | ❌ Opcional     |

> Brave instalado via repo RPM oficial (Brave não recomenda Flatpak por questões de sandbox/segurança).

### 🖥️ Terminal e Sistema

| App            | Tipo                      | Pré-selecionado   |
| -------------- | ------------------------- | ----------------- |
| Kitty Terminal | RPM (DNF)                 | ✅ Obrigatório    |
| Fastfetch      | RPM (DNF)                 | ✅ Sim            |
| NiriMod        | Script / Binário (GitHub) | ✅ Auto (se Niri) |

### 📁 Aplicativos (Grupo GNOME)

| App                                 | Tipo      | Pré-selecionado |
| ----------------------------------- | --------- | --------------- |
| Gerenciador de Arquivos (Nautilus)  | RPM (DNF) | ✅ Sim          |
| Calculadora                         | Flatpak   | ✅ Sim          |
| Visualizador de Imagens (Loupe)     | Flatpak   | ✅ Sim          |
| Leitor de PDF (Evince)              | Flatpak   | ✅ Sim          |
| Gerenciador de Discos               | Flatpak   | ✅ Sim          |
| Scanner de Documentos               | Flatpak   | ✅ Sim          |
| Analisador de Uso de Disco (Baobab) | Flatpak   | ❌ Opcional     |
| Tabela de Caracteres                | Flatpak   | ❌ Opcional     |

### 🎵 Multimídia

| App                             | Tipo    | Pré-selecionado |
| ------------------------------- | ------- | --------------- |
| MPC-QT                          | Flatpak | ✅ Sim          |
| Controle de Áudio (pwvucontrol) | Flatpak | ✅ Sim          |
| VLC                             | Flatpak | ❌ Opcional     |

### 💬 Comunicação

| App               | Tipo    | Pré-selecionado |
| ----------------- | ------- | --------------- |
| Discord           | Flatpak | ❌ Opcional     |
| Telegram          | Flatpak | ❌ Opcional     |
| WhatsApp (ZapZap) | Flatpak | ❌ Opcional     |

### 🔧 Utilitários

| App                           | Tipo    | Pré-selecionado |
| ----------------------------- | ------- | --------------- |
| Warehouse (gerenc. Flatpaks)  | Flatpak | ✅ Sim          |
| Flatseal (permissões Flatpak) | Flatpak | ❌ Opcional     |

### 💻 Desenvolvimento

| App           | Tipo                 | Pré-selecionado |
| ------------- | -------------------- | --------------- |
| Dev Toolbox   | Flatpak              | ❌ Opcional     |
| VSCode        | RPM (repo Microsoft) | ✅ Sim          |
| Git           | RPM (DNF)            | ✅ Sim          |
| Node.js — FNM | Script (curl)        | ✅ Sim          |
| Podman        | RPM (DNF)            | ✅ Sim          |
| Distrobox     | RPM (DNF)            | ❌ Opcional     |
| Docker        | RPM (repo Docker)    | ❌ Opcional     |

---

## Instalações Automáticas (sem aparecer na lista, sempre instaladas)

### Componentes obrigatórios de sistema & hardware

```
# Base Wayland & Sessão
wayland wayland-utils wl-clipboard
xdg-utils xdg-user-dirs
xdg-desktop-portal xdg-desktop-portal-gtk
polkit polkit-gnome                          ← Polkit Agent
pipewire pipewire-alsa pipewire-pulseaudio pipewire-jack wireplumber
pipewire-gstreamer xwaylandvideobridge       ← Screen Sharing em videochamadas
dbus-daemon dbus-broker
accountsservice

# Hardware & Notebook (Lenovo Legion Slim 5i)
switcheroo-control                           ← Alternância Intel/NVIDIA
power-profiles-daemon                        ← Perfis de energia do notebook
brightnessctl                                ← Controle de brilho de tela nas teclas FN
playerctl                                    ← Controle de mídia nas teclas FN
bluez bluez-tools blueman
NetworkManager NetworkManager-wifi iw
cups cups-browsed hplip avahi sane-backends simple-scan

# Nautilus Completo & Miniaturas
udisks2 gvfs gvfs-mtp gvfs-smb gvfs-fuse gvfs-archive
glycin-thumbnailer ffmpegthumbnailer webp-pixbuf-loader
librsvg2 evince-thumbnailer gdk-pixbuf2
file-roller nautilus-extensions

# Fontes e Ícones
google-noto-fonts-all google-noto-emoji-fonts
jetbrains-mono-nerd-font                     ← Ícones e símbolos para terminal e shell
adwaita-icon-theme hicolor-icon-theme

# Utilitários de Terminal
curl wget nano bash-completion htop unzip p7zip p7zip-plugins

# Locale
LANG=pt_BR.UTF-8 + teclado br-abnt2
```

---

## Arquitetura Final do Script

```bash
setup.sh
│
├── ══════════════════════════════════
│   SEÇÃO DE CONFIGURAÇÃO GLOBAL     ← Única seção a editar para adicionar/remover apps
│   (variável APP_LIST com todos os apps)
│   ══════════════════════════════════
│
├── [ETAPA 0]  Verificação: sudo, internet, Fedora, GPU, Secure Boot
├── [ETAPA 1]  Atualização: dnf upgrade --refresh
├── [ETAPA 2]  Repositórios: RPM Fusion, Flathub, COPRs (Niri/Hyprland/DMS)
├── [ETAPA 3]  Base Wayland & Hardware: deps obrigatórias + switcheroo + brightnessctl
├── [ETAPA 4]  Compositor: menu Niri (+ NiriMod + niri-shot) / Hyprland (+ satty) / Nenhum
├── [ETAPA 5]  Shell: menu Noctalia / DMS / Nenhum (se Nenhum → instala Fuzzel)
├── [ETAPA 6]  Greeter: configura greetd + greeter correto
│              ├── Noctalia → noctalia-greeter
│              ├── DMS      → dms-greeter
│              └── Nenhum   → tuigreet
├── [ETAPA 7]  Drivers: Intel automático + NVIDIA pergunta (akmod-nvidia + nvidia-vaapi) + codecs
├── [ETAPA 8]  Hardware: impressoras, scanner backend, bluetooth, wifi, firewall
├── [ETAPA 9]  Apps: menu em grupos com checkboxes + tipo exibido
├── [ETAPA 10] Utilitários automáticos: fontes Nerd, ícones, locale, etc.
├── [ETAPA 11] Geração de Configurações (Dotfiles Prontos):
│              ├── ~/.config/niri/config.kdl (autostart do shell, polkit, FN keys, niri-shot)
│              ├── ~/.config/hypr/hyprland.conf (autostart do shell, polkit, FN keys, grim/satty)
│              ├── /etc/xdg/xdg-desktop-portal/portals.conf
│              └── ~/.bashrc (hook FNM)
├── [ETAPA 12] Serviços: systemctl enable de todos os daemons
└── [ETAPA 13] Resumo estilizado + pergunta de reiniciar
```

---

## Visual do Script (TUI)

- **Tecnologia:** Bash puro + ANSI (sem dialog, whiptail ou dependências)
- **Paleta:** Preto/ciano (identidade Dank Material Shell)
- **Banner:** ASCII art do nome do script
- **Menus:** ↑↓ navega, Enter confirma, Espaço toggle checkbox
- **Cada app na lista mostra:** nome + tipo `[Flatpak]` `[RPM]` `[Script]`
- **Indicadores:** `○ Será instalado`, `✓ Já instalado`, `✗ Pulado`
- **Barras de progresso** durante instalações longas
- **Idioma:** 100% Português do Brasil

---

## Problemas Resolvidos

| Problema                     | Solução                                                     |
| ---------------------------- | ----------------------------------------------------------- |
| Warehouse falhava            | Flatpak+Flathub configurados na Etapa 2, antes de tudo      |
| Tela preta pós-instalação    | greetd + graphical.target habilitados na Etapa 11           |
| SDDM inadequado              | Substituído por greetd (nativo Wayland)                     |
| Miniaturas não apareciam     | glycin, ffmpegthumbnailer, webp-pixbuf-loader, librsvg2     |
| Brave Flatpak com limitações | Instalado via RPM repo oficial                              |
| Screen sharing               | xwaylandvideobridge sempre instalado + portais configurados |
| nvm lento no terminal        | Substituído por FNM (escrito em Rust, muito mais rápido)    |

---

## Pendências (requer plano separado)

> [!IMPORTANT]
> **Ferramenta de Screenshot para Wayland**
> Este é o único ponto ainda não resolvido. O plano de screenshot separado deve decidir entre:
>
> **Opção A (Recomendada):** `grim + slurp + satty`
>
> - Modular, GTK4, funciona nativo no Wayland (Niri e Hyprland)
> - satty = anotação moderna (blur, texto, setas, retângulos)
> - Mais confiável que Flameshot no Wayland
> - Script configura o atalho `Print` para chamar `grim | satty` automaticamente
>
> **Opção B:** `niri-shot` (se usar Niri)
>
> - Ferramenta GTK4 específica para Niri
> - Integração perfeita, mas só funciona com Niri
>
> **Opção C:** `Flameshot`
>
> - Mais familiar visualmente, mas suporte Wayland ainda parcial
> - Já está na lista como opcional
>
> **Decisão pendente com o usuário no próximo plano.**
