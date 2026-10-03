# ---------------------------------------------------------------------------
# Brewfile - `brew bundle` installs everything below.
#   install.sh --brew      # install/upgrade from this file
#   brew bundle dump --force --file=Brewfile   # refresh from the current machine
#
# This is the authoritative list for this Mac. Tools the shell/nvim/tmux
# configs expect (tmux, neovim, oh-my-posh, fzf, zoxide, ...) are included so
# a fresh machine is usable after one `brew bundle`.
# ---------------------------------------------------------------------------

tap "anomalyco/tap"

# ── Shell & prompt ─────────────────────────────────────
brew "tmux"
brew "neovim"
brew "oh-my-posh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "fzf"
brew "zoxide"
brew "direnv"
brew "mise"

# ── CLI essentials ─────────────────────────────────────
brew "git"
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"
brew "btop"
brew "jq"
brew "tree"
brew "wget"

# ── Languages & runtimes ───────────────────────────────
brew "node"
brew "python@3.13"
brew "rust"
brew "go"

# ── Cloud / IaC / DevOps ───────────────────────────────
brew "ansible"
brew "awscli"
brew "kubernetes-cli"
brew "kubectx"
brew "opentofu"

# ── Containers & databases ─────────────────────────────
brew "podman"
brew "podman-compose"
brew "postgresql@18", link: true

# ── Networking / security ──────────────────────────────
brew "nmap"
brew "mtr"

# ── Libraries (Homebrew deps) ──────────────────────────
brew "openssl@3", link: true
brew "libyaml"
brew "gmp"

# ── AI coding agent ────────────────────────────────────
brew "anomalyco/tap/opencode-v2", trusted: true

# ── GUI apps ───────────────────────────────────────────
cask "docker-desktop"
cask "wireshark-app"
cask "gns3"

# ── Fonts ──────────────────────────────────────────────
cask "font-hack-nerd-font"

# ── Cargo binaries ─────────────────────────────────────
cargo "loco"
