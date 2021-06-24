#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT=${DIR}/..

java -jar ${PROJECT_ROOT}/bin/glass.jar $1 ${PROJECT_ROOT}/build/cart.rom
