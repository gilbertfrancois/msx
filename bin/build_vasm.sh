#!/usr/bin/env bash
set +xe

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT=${DIR}/..

rm -f ${PROJECT_ROOT}/build/*

vasmz80_oldstyle ${1} -chklabels -nocase -Dvasm=1 -DBuildMSX=1 -DBuildMSX_MSX1=1 \
    -L ${PROJECT_ROOT}/build/listing.txt \
    -Fbin \
    -o ${PROJECT_ROOT}/build/out.${2}

# ${PROJECT_ROOT}/bin/run_rom.sh
