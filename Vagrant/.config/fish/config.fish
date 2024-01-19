set fish_greeting
set PAGER less
set EDITOR vim

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

alias ls='eza -a --color=always --group-directories-first'
alias ll='eza -al --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'

if test -e ~/.config/fish/work.fish
    source ~/.config/fish/work.fish
end
