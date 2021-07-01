#!/usr/bin/env bash
set +xe

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT=${DIR}/..

vasmz80_oldstyle $1 -chklabels -nocase \
    -Dvasm=1 -DbuildMSX=1 -DBuildMSX_MSX1=1 -Fbin \
    -L ${PROJECT_ROOT}/build/listing.txt \
    -I ${PROJECT_ROOT}/lib/chibiakumas/SrcALL \
    -I ${PROJECT_ROOT}/lib/chibiakumas/SrcMSX \
    -o ${PROJECT_ROOT}/build/cart.rom
