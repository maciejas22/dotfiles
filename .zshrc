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

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow'

source <(fzf --zsh)

alias ls="eza --icons=always"
eval "$(zoxide init zsh --cmd cd)"

# zprof
