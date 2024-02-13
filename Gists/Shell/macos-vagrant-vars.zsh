#!/bin/zsh

export VAGRANT_EXPERIMENTAL="disks"

CALC_MEM=$(expr $(system_profiler SPHardwareDataType | \
    grep Memory: | grep -Eo "[[:digit:]]+") / 4 '*' 1024)

CALC_CPU=$(expr $(system_profiler SPHardwareDataType | \
    grep Cores: | grep -Eo "[[:digit:]]+") / 2)


export GIT_NAME="Guy Chait"
export GIT_EMAIL=""

export DISK_GB=200
export PORT_TCP=8080

export MEMORY=$(( ${CALC_MEM} > 1024 ? ${CALC_MEM} : 1024 ))
export CPUS=$(( ${CALC_CPU} > 1 ? ${CALC_CPU} : 1 ))
