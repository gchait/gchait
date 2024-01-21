if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
zle_highlight=("paste:none")

autoload -Uz compinit && compinit
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

SAVEHIST=1000
HISTFILE=~/.zsh_history

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[3~" delete-char

export EDITOR=vim
export PAGER=

alias ls="eza -a --color=always --group-directories-first"
alias ll="eza -al --color=always --group-directories-first"
alias lt="eza -aT --color=always --group-directories-first"

alias awsp='f(){ if [ -z "$1" ]; then; echo $AWS_PROFILE; else; export AWS_PROFILE="$1"; fi; unset -f f; }; f'
alias d="docker"
alias k="kubectl"

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f ~/.hidden_zshrc ]] && source ~/.hidden_zshrc
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
