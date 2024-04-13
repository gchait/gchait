SAVEHIST=1500
HISTFILE=~/.zsh_history

zle_highlight=("paste:none")
fpath+=($HOME/.zsh/pure)

export EDITOR=vim
export PAGER=more

alias sudo="sudo "
alias flat="flatpak"
alias zyp="zypper"
alias ff="fastfetch -c paleofetch.jsonc"
alias ls="eza -a --group-directories-first"
alias ll="ls -l"
alias lt="ls -T"
alias df="df -hT"
alias j="just"
alias d="docker"
alias k="kubectl"
alias c="code"
alias g="git"

update() {
    if command -v zypper; then
        sudo zypper ref
        sudo zypper dup -yl
    fi

    if command -v flatpak; then
        flatpak update -y
        flatpak uninstall --unused -y
    fi

    if command -v scoop; then
        scoop update -a &> /dev/null
    fi

    git -C ~/gchait pull
}

[[ -f ~/.hidden_zshrc ]] && source ~/.hidden_zshrc
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[3~" delete-char

autoload -Uz compinit && compinit
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

autoload -U promptinit && promptinit
prompt pure
