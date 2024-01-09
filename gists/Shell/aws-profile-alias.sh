alias awsp='f(){ if [ -z "$1" ]; then; echo $AWS_PROFILE; else; export AWS_PROFILE="$1"; fi; unset -f f; }; f'
awsp dev
