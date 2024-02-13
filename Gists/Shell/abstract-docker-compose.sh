#!/bin/bash

export COMPOSE_FILE=compose.yaml
export COMPOSE_PROJECT_NAME=xyz
export DOCKER_SCAN_SUGGEST=false
export COMPOSE_IGNORE_ORPHANS=true

case "${1}" in
1) action="up --detach" reverse="" ;;
0) action="down" reverse="reverse |" ;;
*) echo "Please specify either 1 or 0." >&2 && exit 2 ;;
esac

shift 1

enabled_components=$(yq "${reverse} .[] | select(.enabled) | .path" components.yaml)
disabled_components=$(yq "${reverse} .[] | select(.enabled | not) | .path" components.yaml)

echo "${enabled_components}" | xargs -I {} bash -c "(cd {} && docker compose ${action} ${*} &> /dev/null)"
echo "${disabled_components}" | xargs -I {} bash -c "(cd {} && docker compose down &> /dev/null)"
