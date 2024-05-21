FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

eval "$(starship init zsh)"

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
eval "`fnm env`"

# jenv
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

