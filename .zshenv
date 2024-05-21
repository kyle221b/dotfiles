# Env
export ZDOTDIR=$HOME/.config/zsh
export VISUAL=nvim
export PAGER=bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_PAGER="less -RF"
export BAT_THEME="gruvbox-dark"
export BAT_STYLE="numbers,grid,changes"
export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOME/.config/brew/Brewfile"

# PATH mods

# Rust bin
export PATH=$PATH:$HOME/.cargo/bin

# Go bin
export PATH=$PATH:$HOME/go/bin

# usr .local bin
export PATH=$PATH:$HOME/.local/bin

# Intellij
export PATH=$PATH:/Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS:.

# fnm
export PATH="/Users/kyle.baylor/Library/Application Support/fnm:$PATH"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
