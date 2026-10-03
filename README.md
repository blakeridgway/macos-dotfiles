# macOS dotfiles

My macOS workstation setup: shell, git, tmux, Neovim, Homebrew, and a handful
of `defaults write` tweaks. Managed with a small `install.sh` that symlinks
things into `$HOME`; no framework to learn.

> This is the macOS counterpart to the Linux/Debian [`dotfiles`](https://gitlab.com/blakeridgway/dotfiles)
> repo. The good bits (aliases, nvim, tmux, git config) were salvaged from it,
> but the installer and defaults here are macOS-specific.

## Quick start

```bash
git clone <this-repo> ~/dev/Personal/macos_dotfiles   # already here
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
| `config/oh-my-posh/theme.omp.json` | `~/.config/oh-my-posh/theme.omp.json` | prompt theme |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | mise tool versions |
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
Homebrew has installed anything. The prompt is [oh-my-posh](https://ohmyposh.dev).

`.zprofile` and `.zshenv` are **not** managed here: Docker Desktop and rustup
rewrite them on their own, and symlinking them would either fight those tools
or dirty the repo. Cargo and the Docker CLI path are handled in `zshrc` instead.

**Git** – your name/email, `rebase` on pull, `autoSetupRemote`, a histogram
diff, `zdiff3` merge conflicts, `rerere`, and a few short aliases (`gs`, `gl`,
`co`, `undo`). The work identity is included only under `~/dev/AdvancedMetrics/`.

**Homebrew** – the `Brewfile` is the source of truth. It includes the CLI tools
the configs expect (tmux, neovim, oh-my-posh, fzf, zoxide, direnv, mise, eza,
bat, fd, ripgrep, btop) plus what was already installed. Refresh it with:

```bash
brew bundle dump --force --file=Brewfile
```

**macOS defaults** – `macos/defaults.sh` is opt-in and covers Finder, Dock,
screenshots, key repeat, tap-to-click, the menu-bar clock and TextEdit. Preview
with `./macos/defaults.sh --dry-run`.

**Neovim** – the NvChad v2.5 config from the old repo, minus a broken symlink
that pointed at `/home/blake/dotfiles/nvim` on the Linux box.

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
