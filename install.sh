#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# install.sh - bootstrap this macOS dotfiles repo.
#
#   ./install.sh                 # symlink dotfiles into $HOME (safe, idempotent)
#   ./install.sh --dry-run       # show every action, change nothing
#   ./install.sh --brew          # also run `brew bundle`
#   ./install.sh --macos         # also apply macos/defaults.sh
#   ./install.sh --all           # symlinks + brew + macOS defaults
#
# Anything already in the way is moved to ~/.dotfiles-backup/<timestamp>/
# instead of being deleted. A real directory is never removed.
# ---------------------------------------------------------------------------
set -euo pipefail

DRY_RUN=0
RUN_BREW=0
RUN_MACOS=0

usage() {
  sed -n '2,14p' "$0" | sed 's/^# \?//'
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --brew)    RUN_BREW=1 ;;
    --macos)   RUN_MACOS=1 ;;
    --all)     RUN_BREW=1; RUN_MACOS=1 ;;
    -h|--help) usage ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_LINK="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKED_UP=0

run() {
  if [[ $DRY_RUN -eq 1 ]]; then printf '  [dry-run] %s\n' "$*"; else "$@"; fi
}

backup() {
  local dest="$1"
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '  [dry-run] back up %s -> %s/\n' "$dest" "$BACKUP_DIR"
    return 0
  fi
  mkdir -p "$BACKUP_DIR"
  mv "$dest" "$BACKUP_DIR/"
  BACKED_UP=1
  printf '  backed up %s -> %s/\n' "$dest" "$BACKUP_DIR"
}

# link <relative-source> <relative-destination-under-$HOME>
link() {
  local rel_src="$1" rel_dest="$2"
  local real_src="$ROOT/$rel_src"        # where the file really lives
  local src="$DOTFILES_LINK/$rel_src"    # what the symlink points at
  local dest="$HOME/$rel_dest"

  printf '==> %s -> %s\n' "$dest" "$src"

  if [[ ! -e "$real_src" && ! -L "$real_src" ]]; then
    printf '  ! source missing, skipping: %s\n' "$real_src"
    return 0
  fi

  run mkdir -p "$(dirname "$dest")"

  if [[ -d "$real_src" && ! -L "$real_src" ]]; then
    # Directory link. Replacing a real directory would destroy data.
    if [[ -d "$dest" && ! -L "$dest" ]]; then
      printf '  ! %s is a real directory - refusing to replace it\n' "$dest"
      printf '    move it aside first:  mv "%s" "%s.bak"\n' "$dest" "$dest"
      return 1
    fi
    run ln -sfn "$src" "$dest"
    return 0
  fi

  # File link.
  if [[ -L "$dest" ]]; then
    run rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    backup "$dest"
  fi
  run ln -sfn "$src" "$dest"
}

# ── 1. stable ~/.dotfiles symlink ------------------------------------------
echo "==> Pointing $DOTFILES_LINK at $ROOT"
if [[ -L "$DOTFILES_LINK" ]]; then
  run rm -f "$DOTFILES_LINK"
  run ln -sfn "$ROOT" "$DOTFILES_LINK"
elif [[ -e "$DOTFILES_LINK" ]]; then
  echo "  ! $DOTFILES_LINK exists and is not a symlink; leaving it alone" >&2
  echo "    remove or move it, then re-run." >&2
  exit 1
else
  run ln -sfn "$ROOT" "$DOTFILES_LINK"
fi

# ── 2. symlink the dotfiles ------------------------------------------------
# src|dest pairs. Directories (nvim, nushell) are detected automatically.
MAP=(
  "shell/zshrc|.zshrc"
  "shell/aliases.zsh|.aliases.zsh"
  "shell/bashrc|.bashrc"
  "shell/aliases.bash|.aliases.bash"
  "git/gitconfig|.gitconfig"
  "git/gitignore|.gitignore"
  "git/commit-conventions.txt|.commit-conventions.txt"
  "terminal/tmux.conf|.tmux.conf"
  "terminal/nushell|.config/nushell"
  "nvim|.config/nvim"
  "config/oh-my-posh/theme.omp.json|.config/oh-my-posh/theme.omp.json"
  "config/mise/config.toml|.config/mise/config.toml"
)

for entry in "${MAP[@]}"; do
  link "${entry%%|*}" "${entry##*|}"
done

# ── 3. optional extras ------------------------------------------------------
if [[ $RUN_BREW -eq 1 ]]; then
  echo "==> Homebrew bundle"
  if command -v brew >/dev/null; then
    run brew bundle --file="$ROOT/Brewfile"
  else
    echo "  ! Homebrew not found - install it from https://brew.sh first" >&2
  fi
fi

if [[ $RUN_MACOS -eq 1 ]]; then
  echo "==> macOS defaults"
  run bash "$ROOT/macos/defaults.sh"
fi

# ── 4. summary --------------------------------------------------------------
echo
if [[ $DRY_RUN -eq 1 ]]; then
  echo "Dry run complete - nothing changed."
else
  echo "Done."
  [[ $BACKED_UP -eq 1 ]] && echo "Previous files were saved under $BACKUP_DIR/"
  echo "Open a new terminal (or run 'exec zsh') to pick up the new config."
  [[ $RUN_BREW -eq 0 ]] && echo "Tip: './install.sh --brew' installs the Homebrew packages."
  [[ $RUN_MACOS -eq 0 ]] && echo "Tip: './install.sh --macos' applies the macOS defaults."
fi
