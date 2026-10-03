# macOS dotfiles

My macOS workstation setup: shell, git, tmux, Neovim, Homebrew, and a handful
of `defaults write` tweaks. Managed with a small `install.sh` that symlinks
things into `$HOME`; no framework to learn.

> This is the macOS counterpart to the Linux/Debian [`dotfiles`](https://gitlab.com/blakeridgway/dotfiles)
> repo. The good bits (aliases, nvim, tmux, git config) were salvaged from it,
> but the installer and defaults here are macOS-specific.

## Quick start

```bash
git clone git@github.com:blakeridgway/macos-dotfiles.git ~/dev/Personal/macos_dotfiles
cd ~/dev/Personal/macos_dotfiles
./install.sh --dry-run     # see exactly what would happen
./install.sh               # symlink the dotfiles into $HOME
./install.sh --brew        # also install the Homebrew packages
./install.sh --macos       # also apply the macOS defaults
```

Or do everything at once with `./install.sh --all`.

Existing files in the way are **moved** to `~/.dotfiles-backup/<timestamp>/`,
never deleted. A real directory is never replaced by a symlink.

## Layout

| Path | Links to | What it is |
|---|---|---|
| `shell/zshrc` | `~/.zshrc` | zsh: PATH, history, completions, prompt, tool hooks |
| `shell/aliases.zsh` | `~/.aliases.zsh` | aliases (sourced by `zshrc`) |
| `shell/bashrc` | `~/.bashrc` | minimal bash equivalent |
| `shell/aliases.bash` | `~/.aliases.bash` | bash aliases |
| `git/gitconfig` | `~/.gitconfig` | global git config |
| `git/gitconfig-advancedmetrics` | – | work identity, included for `~/dev/AdvancedMetrics/` |
| `git/gitignore` | `~/.gitignore` | global ignore (set via `core.excludesfile`) |
| `git/commit-conventions.txt` | `~/.commit-conventions.txt` | commit message template |
| `terminal/tmux.conf` | `~/.tmux.conf` | self-explanatory tmux (mouse, big scrollback) |
| `terminal/nushell/` | `~/.config/nushell` | nushell config |
| `nvim/` | `~/.config/nvim` | Neovim (NvChad v2.5 + lazy.nvim) |
| `config/oh-my-posh/theme.omp.json` | `~/.config/oh-my-posh/theme.omp.json` | active prompt theme (catppuccin_mocha) |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | mise tool versions |
| `config/iterm2/catppuccin-mocha.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/catppuccin-mocha.json` | iTerm2 dynamic profile (Catppuccin Mocha + Nerd Font) |
| `Brewfile` | – | Homebrew packages and apps |
| `macos/defaults.sh` | – | optional macOS `defaults write` tweaks |
| `ssh/config.example` | – | starter SSH config (copy to `~/.ssh/config`) |

`install.sh` also creates `~/.dotfiles`, a stable symlink back to this repo.
Config files reference that path, so the repo can live anywhere without
rewriting them. (This is why `gitconfig` uses `~/.dotfiles/...` rather than a
hardcoded clone path.)

## Components

**Shell** – plain zsh, no oh-my-zsh. Homebrew's `shellenv`, a 100k-entry shared
history, `compinit`, and guarded hooks for `mise`, `direnv`, `zoxide` and
`fzf`. Every optional tool is behind `command -v`, so the config works before
Homebrew has installed anything.

**Prompt & theme** – [oh-my-posh](https://ohmyposh.dev) with the
`catppuccin_mocha` theme (`config/oh-my-posh/theme.omp.json`; the theme that
was salvaged from the old repo is kept as `custom.omp.json`). The prompt needs
a Nerd Font for its glyphs: install `font-hack-nerd-font` (in the `Brewfile`)
and select **Hack Nerd Font** in your terminal profile (iTerm2:
*Settings → Profiles → Text → Font*). [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
are loaded too — the latter last, as it requires.

**iTerm2** – `config/iterm2/catppuccin-mocha.json` is an iTerm2 *dynamic profile*
that inherits your `Default` profile, applies the official Catppuccin Mocha
colors, and sets `HackNFM-Regular 14`. `install.sh` symlinks it into iTerm2's
`DynamicProfiles` folder; iTerm2 reloads it live. To make it the one used for
new windows: *Settings → Profiles → Catppuccin Mocha → Other Actions → Set as
Default*.

`.zprofile` and `.zshenv` are **not** managed here: Docker Desktop and rustup
rewrite them on their own, and symlinking them would either fight those tools
or dirty the repo. Cargo and the Docker CLI path are handled in `zshrc` instead.

**Git** – your name/email, `rebase` on pull, `autoSetupRemote`, a histogram
diff, `zdiff3` merge conflicts, `rerere`, and a few short aliases (`gs`, `gl`,
`co`, `undo`). The work identity is included only under `~/dev/AdvancedMetrics/`.

**Homebrew** – the `Brewfile` is the source of truth and is aimed at
**DevSecOps/SRE + Ruby on Rails**, with **Rust and Go** toolchains. Broadly:

- *Shell/dev:* tmux, neovim, oh-my-posh, the zsh plugins, fzf, zoxide, direnv,
  mise, git, gh, ripgrep, fd, bat, eza, btop, jq, yq
- *Runtimes:* Go (+ golangci-lint, delve, gopls, staticcheck), Rust
  (+ rust-analyzer, cargo-audit/deny/nextest/watch). **Ruby is managed by
  mise**, not brew; the `Ruby on Rails` block is the native build/runtime deps
  (postgresql@18, redis, libpq, vips, imagemagick, openssl, libyaml, …).
- *Cloud/IaC (AWS):* awscli, aws-vault, ansible(+lint), opentofu, terragrunt,
  packer, tflint, checkov
- *Kubernetes/SRE:* kubernetes-cli, kubectx, k9s, helm, kustomize, stern, kind,
  kubeseal, mtr, iperf3
- *Supply-chain security:* trivy, grype, syft, cosign
- *Secrets/leaks:* sops, age, gitleaks, gnupg
- *CI & load testing:* act, k6, hey, vegeta
- *Containers:* **colima + docker/docker-compose/buildx** (replaces the broken
  Docker Desktop cask) and dive

`packer` and `tflint` come from third-party taps and are marked
`trusted: true`. Refresh the file from the current machine with:

```bash
brew bundle dump --force --file=Brewfile
```

**macOS defaults** – `macos/defaults.sh` is opt-in and covers Finder, Dock,
screenshots, key repeat, tap-to-click, the menu-bar clock and TextEdit. Preview
with `./macos/defaults.sh --dry-run`.

**Neovim** – the NvChad v2.5 config from the old repo, minus a broken symlink
that pointed at `/home/blake/dotfiles/nvim` on the Linux box.

## Services (on demand)

Nothing here is configured to start at login — databases, the container VM and
clusters are started only when you need them, to keep memory free. Handy
aliases: `pgstart`/`pgstop`, `redisstart`/`redisstop`,
`dockerstart`/`dockerstop`, and `svc` (= `brew services list`).

| Need | Start | Stop |
|---|---|---|
| PostgreSQL 18 | `brew services start postgresql@18` | `brew services stop postgresql@18` |
| Redis | `brew services start redis` | `brew services stop redis` |
| Container VM (colima) | `colima start` | `colima stop` |
| Kubernetes (kind) | `kind create cluster` | `kind delete cluster` |

`brew services stop` unregisters the launch agent as well as stopping it, so a
service you stop stays off across reboots. `install.sh --brew` only installs
packages; it never starts a service.

## Local overrides & secrets

Machine-specific settings go in files that are gitignored:

- `~/.zshrc.local` and `~/.bashrc.local` (sourced at the end of the shell rc)
- `~/.secrets` (sourced, keep it `chmod 600`)
- `~/.ssh/config` (start from `ssh/config.example`)

## Restoring the previous setup

Everything this installer replaced is under `~/.dotfiles-backup/<timestamp>/`.
To roll back a single file, move it back over the symlink:

```bash
rm ~/.zshrc && mv ~/.dotfiles-backup/<timestamp>/.zshrc ~/
```
