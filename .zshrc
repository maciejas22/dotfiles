# zmodload zsh/zprof

[ -f ~/.zsh_env ] && source ~/.zsh_env

HISTFILE=~/.zshistory
HISTSIZE=1000
SAVEHIST=1000
unsetopt autocd beep
bindkey -v

export PROMPT='%m:%~ %# '

zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

ZPLUGINSDIR=${ZPLUGINSDIR:-$HOME/.config/zsh/plugins}
function plugin-load {
  local repo plugdir initfile initfiles=()
  : ${ZPLUGINSDIR:?}
  for repo in $@; do
    plugdir=$ZPLUGINSDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

plugins=(
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-autosuggestions.git
  Aloxaf/fzf-tab.git
)
plugin-load $plugins

function tool-load {
  local tool missing_tools=()
  
  for tool in $@; do
    if ! command -v $tool &> /dev/null; then
      echo "⚠️ $tool is not installed."
      missing_tools+=($tool)
    fi
  done
  
  if (( ${#missing_tools[@]} > 0 )); then
    echo "Installing missing tools with Homebrew..."
    
    if ! command -v brew &> /dev/null; then
      echo "Homebrew is not installed." 
      return 1
    fi
    
    for tool in "${missing_tools[@]}"; do
      echo "Installing $tool..."
      brew install $tool
      
      if ! command -v $tool &> /dev/null; then
        echo "Failed to install $tool."
      fi
    done
  fi
}

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow'

tools=(
  bat
  fd
  fzf
  eza
  zoxide
)
tool-load $tools


source <(fzf --zsh)

alias ls="eza --icons=always"
eval "$(zoxide init zsh --cmd cd)"

# zprof
