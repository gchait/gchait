set fish_greeting
set PAGER
set EDITOR nvim

function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

function backup --argument filename
    cp $filename $filename.bak
end

function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

function coln
    while read -l input
        echo $input | awk '{print $'$argv[1]'}'
    end
end

function rown --argument index
    sed -n "$index p"
end

function skip --argument n
    tail +(math 1 + $n)
end

function awsp --argument profile
    if test -z $profile
        echo $AWS_PROFILE
    else
        set -xg AWS_PROFILE $profile
        return 0
    end
end

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias ls='exa -a --color=always --group-directories-first'
alias ll='exa -al --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias ldot='exa -a | grep -E "^\."'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

alias vi='nvim'
alias vim='nvim'
alias oldvim='\vim'
alias vimdiff='nvim -d'
