FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

eval "$(starship init zsh)"

# load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

# if the init script doesn't exist
if ! zgenom saved; then
  # specify plugins here
  zgenom ohmyzsh

  # plugins
  zgenom ohmyzsh kube-ps1
  zgenom ohmyzsh plugins/aliases
  zgenom ohmyzsh plugins/brew
  zgenom ohmyzsh plugins/docker
  zgenom ohmyzsh plugins/fd
  zgenom ohmyzsh plugins/fzf
  zgenom ohmyzsh plugins/git
  zgenom ohmyzsh plugins/poetry
  zgenom ohmyzsh plugins/ripgrep
  zgenom ohmyzsh plugins/zoxide

  zgenom load MichaelAquilina/zsh-you-should-use
  zgenom load dbz/kube-aliases
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-completions
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load zsh-users/zsh-syntax-highlighting

  # other completions
  zgenom load Downager/zsh-helmfile
  zgenom load zap-zsh/fnm

  # generate the init script from plugins above
  zgenom save
fi

# aliases
alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias soz="source ~/.config/zsh/.zshrc"
alias vim=nvim
alias vimz="vim ~/.config/zsh/.zshrc"
alias vimc="cd ~/.config && vim"
alias vimcv="cd ~/.config/nvim && vim"
alias batz="bat ~/.config/zsh/.zshrc"
alias brewi="brew install"
alias caski="brewi --cask"
alias ddt=dd-toolbox
alias obsidian="vim ~/Documents/vault"
alias pip=pip3
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | pbcopy"

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
function gzsw {
  gsw $(g branch -a | fzff)
}

alias docker-compose="docker compose"

alias t="tmux"


alias fzff="fzf -0 --height=~40%" # FZF friendly

alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
alias kpf="k port-forward"
alias keit="k exec -it"
alias kzp="kgp | tail -n +2 | choose 0 | fzff"
alias kzs="kgs | tail -n +2 | choose 0 | fzff"

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
alias dbl="$HOME/Projects/devbox-cli/dist/devbox-cli_0.dev_darwin_arm64/devbox-cli"
alias dbs="db setup"
alias dbr="db run"
alias dbt="db teardown"
alias dbdv="db runtime-dv"
alias dbd="db doctor"
alias dbw="db workspace"
alias dbsg="dbs geo-web"
alias dbrg="dbr geo-web"
alias dbtg="dbt geo-web"
alias dbsgr="dbs geo-web-remote"
alias dbrgr="dbr geo-web-remote"
alias dbtgr="dbt geo-web-remote"

alias ts="tailscale"
alias tsu="ts up"
alias tsd="ts down"

alias tf="terraform"

alias kill-grpc="lsof -i :50051 | rg \"LISTEN|ESTABLISHED\" | choose 1 | xargs kill -9"

# Completions
# zstyle ':completion:*' use-cache on
source <(ddt completion zsh)
source <(av completion zsh)
source <(tailscale completion zsh)

# fnm
eval "`fnm env`"

# jenv
eval "$(jenv init -)"

# fzf
source ~/Projects/personal/fzf-git.sh/fzf-git.sh

# direnv
eval "$(direnv hook zsh)"

function dotsync {
  dot commit -a -m ${1-"Sync dotfiles"}
  dot push
}

function pws {
  cd ~/Projects/personal/$1
}

function ws {
  cd ~/Projects/$1
}

function ghcr {
  ws && gh repo clone doordash/$1 && cd $1
}

function gza() {
  local files branch
  g ls-files -d -m -o --exclude-standard | fzf --height=~100% -m | xargs git add
}

function gzsw() {
  local branches branch
  branches=$(git --no-pager branch -vv)
  branch=$(echo "$branches" | fzf --height=~100% +m)
  git switch $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

function gzb() {
  local branches branch
  branches=$(git --no-pager branch -vv)
  echo "$branches" | fzf --height=~100% | awk '{print $1}'
}

function tsh-login {
  tsh kube ls | fzf | choose 0 | xargs tsh kube login
}

function sandbox {
  tsh kube login sandbox-cell-001.prod-main-us-west-2
}

function sandbox2 {
  tsh kube login sandbox-cell-002.prod-main-us-west-2
}

function sandbox3 {
  tsh kube login sandbox-cell-003.prod-main-us-west-2
}

function sandbox4 {
  tsh kube login sandbox-cell-004.prod-main-us-west-2
}

function cell1 {
  tsh kube login cell-001-00.cell-001.prod-main-us-west-2
}

function cell2 {
  tsh kube login cell-002-00.cell-002.prod-main-us-west-2
}

function cell3 {
  tsh kube login cell-003-00.cell-003.prod-main-us-west-2
}

function cell4 {
  tsh kube login cell-004-00.cell-004.prod-main-us-west-2
}

function ktl {
  kl -f $1 | bat --style=plain --paging=never -l log
}

function keitb {
  pod=$(kzp)
  echo "Running bash in pod $pod"
  keit $pod -- bash
}

function sbd {
  pod_name=$(kgp | rg $1 | choose 0)
  port=${2-50051}
  echo "Setting up port-forwarding for pod $pod_name"
  k port-forward $pod_name $port &
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

function geo-client {
  vault kv list secret_v2/geo-intelligence/geo-intelligence/web | tail -n +3 | xargs -I{} vault kv get -format=json secret_v2/geo-intelligence/geo-intelligence/web/{} | jq '.data.data | map_values(fromjson) | to_entries | map({ key: .key, name: .value.name })[0]' 2>/dev/null | rg -B 1 -A 2 $1
}

function nectar-update {
  for document_id in ${(f)@}; do
    echo "Upserting document $document_id"
    echo "{ \"document_id\": \"$document_id\", \"change_type\": \"upsert\" }" | kcat -F ~/kafka/production-02/kcat.properties -t geo-intelligence-platform__nectar-document-updates -P
  done
}

