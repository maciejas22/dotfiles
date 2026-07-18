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
  local plugin repo commitsha plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
  for plugin in $@; do
    repo="$plugin"
    clone_args=(-q --depth 1 --recursive --shallow-submodules)
    if [[ "$plugin" == *'@'* ]]; then
      repo="${plugin%@*}"
      commitsha="${plugin#*@}"
      clone_args+=(--no-checkout)
    fi
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone "${clone_args[@]}" https://github.com/$repo $plugdir
      if [[ -n "$commitsha" ]]; then
        git -C $plugdir fetch -q origin "$commitsha"
        git -C $plugdir checkout -q "$commitsha"
      fi
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file found '$repo'." && continue }
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
