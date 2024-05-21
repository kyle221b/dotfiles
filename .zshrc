source ~/.bash_profile
eval "$(starship init zsh)"

# Brew autocompletions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Env
export VISUAL=nvim
export PAGER=bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_PAGER="less -RF"
export BAT_THEME="gruvbox-dark"
export BAT_STYLE="numbers,grid,changes"
export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOME/.config/brew/Brewfile"

# Rust bin
export PATH=$PATH:$HOME/.cargo/bin

# Go bin
export PATH=$PATH:$HOME/go/bin

# usr .local bin
export PATH=$PATH:$HOME/.local/bin

# Intellij
export PATH=$PATH:/Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS:.

# load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

# if the init script doesn't exist
if ! zgenom saved; then
  # specify plugins here
  zgenom ohmyzsh

  # plugins
  zgenom ohmyzsh plugins/git
  zgenom ohmyzsh plugins/sudo
  zgenom ohmyzsh plugins/aliases
  zgenom ohmyzsh plugins/brew
  zgenom ohmyzsh plugins/docker
  zgenom ohmyzsh plugins/fd
  zgenom ohmyzsh plugins/ripgrep
  zgenom ohmyzsh plugins/fzf
  zgenom ohmyzsh plugins/zoxide
  zgenom ohmyzsh plugins/terraform
  zgenom ohmyzsh kube-ps1

  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-completions
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load MichaelAquilina/zsh-you-should-use
  zgenom load dbz/kube-aliases

  # other completions
  zgenom load zap-zsh/fnm
  zgenom load Downager/zsh-helmfile
  zgenom load bonnefoa/kubectl-fzf

  # generate the init script from plugins above
  zgenom save
fi

# aliases
alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias soz="source ~/.zshrc"
alias vim=nvim
alias brewi="brew install"
alias caski="brewi --cask"
alias ddt=dd-toolbox
alias obsidian="vim ~/Documents/vault"
alias pip=pip3

alias cd=z
alias ls="eza"
alias ll="ls -l"

alias gw="./gradlew"
alias gwc="gw compileKotlin compileTestKotlin"

alias grp="g rev-parse"
alias grph="g rev-parse head"
alias gswC="gsw -C"
function gswr {
  # Reset current branch to it's upstream ref
  gswC $(git_current_branch) $(grp @{u})
}

alias t="tmux"

alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
alias kpf="k port-forward"
alias keit="k exec -it"

alias avs="av stack"
alias avsn="avs next"
alias avsp="avs prev"
alias avst="avs tree"
alias avss="avs sync"
alias avssc="avss --continue"
alias avssa="avss --abort"
function avssf {
  branch=$(git_current_branch)
  for ((;;)) {
    avss --current
    avsn 1>/dev/null 2>/dev/null
    [ $? != 0 ] && gsw $branch 1>/dev/null 2>/dev/null && break
  }
}

alias db="devbox"
alias dbs="db setup"
alias dbr="db run"
alias dbsg="dbs geo-web"
alias dbrg="dbr geo-web"

# Completions
# zstyle ':completion:*' use-cache on
source <(ddt completion zsh)
source <(av completion zsh)

# fnm
export PATH="/Users/kyle.baylor/Library/Application Support/fnm:$PATH"
eval "`fnm env`"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# fzf
source ~/Projects/personal/fzf-git.sh/fzf-git.sh

function pws {
  cd ~/Projects/personal/$1
}

function ws {
  cd ~/Projects/$1
}

function ghcr {
  ws && gh repo clone doordash/$1 && cd $1
}

function tsh-login {
  tsh kube ls | fzf | choose 0 | xargs tsh kube login
}

function ktl {
  kl -f $1 | bat --style=plain --paging=never -l log
}

function sbd {
  pod_name=$(kgp | rg $1 | choose 0)
  echo "Setting up port-forwarding for pod $pod_name"
  k port-forward $pod_name 50051 &
  trap "kill -INT -$!" INT
  ktl $pod_name
}

function docker-login {
  aws --region us-west-2 ecr get-login-password | docker login --username AWS --password-stdin 611706558220.dkr.ecr.us-west-2.amazonaws.com
  aws --region us-west-2 ecr get-login-password | docker login --username AWS --password-stdin 839591177169.dkr.ecr.us-west-2.amazonaws.com
}

function dbgstart {
  dbgs -r $1
  echo "Press enter to continue with sync once sandbox is deployed"
  read
  dbgr -r $1
  sbd $1
}

function coords {
  coordinates=${1-$(pbpaste)}
  grpc_coordinates=$(echo $coordinates | jq -R 'split(",") | map(gsub("^ +| +$";"") | tonumber | {"value":.}) | {"lat":.[0], "lng":.[1]}')
  echo $grpc_coordinates
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$PATH:$HOME/.maestro/bin

# DD specific functions

function nectar-connect {
  broker=$(kgp -n argo-search-nectar | rg broker | head -n 1 | choose 0)
  port=${1:-50051}
  k port-forward $broker $port:50051
}
