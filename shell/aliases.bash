# ---------------------------------------------------------------------------
# ~/.aliases.bash  ->  dotfiles/shell/aliases.bash
# Bash equivalent of aliases.zsh. Keep the two files in sync.
# ---------------------------------------------------------------------------

# ── Unix / navigation ──────────────────────────────────
alias ll="ls -la"
alias la="ls -A"
alias mkdir="mkdir -p"
alias path='echo $PATH | tr -s ":" "\n"'
alias e="$EDITOR"
alias v="$VISUAL"

# ── Network ────────────────────────────────────────────
alias ip6="curl -6 icanhazip.com"
alias myip="curl -4 icanhazip.com"
alias ports='lsof -nP -iTCP -sTCP:LISTEN'
alias pingg='ping -c 4 8.8.8.8'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# ── Git ────────────────────────────────────────────────
alias ga="git add"
alias gaa="git add ."
alias gc="git commit "
alias gp='git push -u origin "$(git symbolic-ref --short HEAD)"'
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate -20"
alias nah="git reset --hard; git clean -df;"

# ── Python ─────────────────────────────────────────────
alias initvenv='python3 -m venv venv'
alias startvenv='source venv/bin/activate'
alias stopvenv='deactivate'
alias py='python3'
alias py3='python3'
alias python='python3'
alias pip='pip3'

# ── Shell / config reloads ─────────────────────────────
alias tmux='tmux -u'
alias tmuxreload='source ~/.tmux.conf'
alias bashreload='source ~/.bashrc'
alias dotfiles='cd "$DOTFILES"'

# ── Editor shortcuts ───────────────────────────────────
alias vim=nvim
alias vi=nvim

# ── macOS Finder helpers ───────────────────────────────
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

# ── Kubernetes ─────────────────────────────────────────
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kx='kubectx'
alias kn='kubens'

# ── Terraform / OpenTofu ───────────────────────────────
alias tf='terraform'
alias tfi='terraform init'
alias tfa='terraform apply'
alias tfp='terraform plan'
alias tfd='terraform destroy'
alias tff='terraform fmt -recursive'
alias tfv='terraform validate'
alias tfo='terraform output'

# ── Docker / Containers ────────────────────────────────
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
