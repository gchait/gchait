#!/bin/bash

PASS_LEN=${PASS_LEN:-xxx}
SCRIPT_NAME=$(basename "$0")
ARGS="$*"
SEAL_CMD="/usr/bin/env kubeseal --controller-namespace sealed-secrets -o yaml --allow-empty-data --scope xxx"
TMP_FILE=/tmp/sealedsecret.yaml

while getopts "h?pi:" opt; do
  case "$opt" in
    h|\?)
      echo '+------------------------------------HELP------------------------------------+'
      echo '| This script can generate a SealedSecret from a given Secret.               |'
      echo '| It can also generate a random "password" value.                            |'
      echo '| To include a random password, specify the -p argument.                     |'
      echo '| Set the -i argument to the path of the Secret file.                        |'
      echo '| You can export PASS_LEN before running to set a custom password length.    |'
      echo '+----------------------------------------------------------------------------+'
      exit 0
      ;;
    p)
        # shellcheck disable=SC2181
        password=$(export LC_CTYPE=C; false; while [ $? -ne 0 ]; do tr -dc A-Za-z0-9 < /dev/urandom | \
                   head -c "$PASS_LEN"; done)
      ;;
    i)  input_file=$OPTARG
      ;;
  esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

if [ -n "$1" ]; then
    echo "Unknown argument: $1" >&2
    exit 2
fi

if [ -z "$input_file" ]; then
    echo "Required argument is missing: -i <file containing a Kubernetes Secret>." >&2
    exit 2
fi

if [ ! -f "$input_file" ]; then
    echo "File not found: $input_file." >&2
    exit 1
fi

input=$(yq 'del(.metadata.namespace)' "$input_file" | sed '/ null$/d')
echo "$input" | $SEAL_CMD > $TMP_FILE
name=$(yq '.metadata.name' "$input_file")

if [ -n "$password" ]; then
    echo -n "$password" | kubectl create secret generic "$name" \
        --dry-run=client --from-file=password=/dev/stdin -o yaml | \
        $SEAL_CMD --merge-into $TMP_FILE
fi

result=$(sed '/ null$/d' $TMP_FILE)
rm -f $TMP_FILE

echo "# Input:"
echo "# ---"
# shellcheck disable=SC2001
echo "$input" | sed 's/^/# /g'
echo

echo "# Result:"
echo ---
echo "$result" | yq 'del(.spec.template)'
echo