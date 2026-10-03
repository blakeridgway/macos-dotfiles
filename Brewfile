# ---------------------------------------------------------------------------
# Brewfile - DevSecOps / SRE + Ruby on Rails (+ Rust & Go)
#
#   ./install.sh --brew                        # install/upgrade from this file
#   brew bundle dump --force --file=Brewfile   # refresh from the current machine
#
# Ruby itself is managed by mise (see config/mise/config.toml), not brew; the
# packages listed under "Ruby on Rails" are the native build/runtime deps.
# ---------------------------------------------------------------------------

tap "anomalyco/tap"
tap "hashicorp/tap"
tap "terraform-linters/tap"

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
brew "git-delta"
brew "gh"
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"
brew "btop"
brew "jq"
brew "yq"
brew "tree"
brew "wget"
brew "httpie"
brew "watch"
brew "gnupg"

# ── Languages & runtimes ───────────────────────────────
brew "node"
brew "python@3.13"
brew "rust"
brew "go"

# ── Go tooling ─────────────────────────────────────────
brew "golangci-lint"
brew "delve"
brew "gopls"
brew "staticcheck"

# ── Rust tooling ───────────────────────────────────────
brew "rust-analyzer"
brew "cargo-audit"
brew "cargo-deny"
brew "cargo-nextest"
brew "cargo-watch"

# ── Ruby on Rails ──────────────────────────────────────
# Ruby via mise; these are the native deps gems build against.
brew "redis"
brew "libpq"
brew "vips"
brew "imagemagick"
brew "shared-mime-info"
brew "pkg-config"
brew "autoconf"
brew "openssl@3"
brew "libyaml"
brew "gmp"
brew "readline"
brew "overmind"

# ── Databases ──────────────────────────────────────────
brew "postgresql@18", link: true

# ── Containers ─────────────────────────────────────────
brew "colima"
brew "docker"
brew "docker-compose"
brew "docker-buildx"
brew "dive"

# ── Cloud & IaC (AWS) ──────────────────────────────────
brew "awscli"
brew "aws-vault"
brew "ansible"
brew "ansible-lint"
brew "opentofu"
brew "terragrunt"
brew "hashicorp/tap/packer", trusted: true
cask "terraform-linters/tap/tflint", trusted: true
brew "checkov"

# ── Kubernetes & SRE ───────────────────────────────────
brew "kubernetes-cli"
brew "kubectx"
brew "k9s"
brew "helm"
brew "kustomize"
brew "stern"
brew "kind"
brew "kubeseal"
brew "mtr"
brew "iperf3"

# ── Supply-chain security ──────────────────────────────
brew "trivy"
brew "grype"
brew "syft"
brew "cosign"

# ── Secrets & leak detection ───────────────────────────
brew "sops"
brew "age"
brew "gitleaks"

# ── CI & load testing ──────────────────────────────────
brew "act"
brew "k6"
brew "hey"
brew "vegeta"

# ── Networking ─────────────────────────────────────────
brew "nmap"

# ── AI coding agent ────────────────────────────────────
brew "anomalyco/tap/opencode-v2", trusted: true

# ── GUI apps ───────────────────────────────────────────
cask "wireshark-app"
cask "gns3"

# ── Fonts ──────────────────────────────────────────────
cask "font-hack-nerd-font"

# ── Cargo binaries ─────────────────────────────────────
cargo "loco"
