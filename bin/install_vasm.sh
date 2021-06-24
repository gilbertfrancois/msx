#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT=${DIR}/..

CWD=`pwd`
cd /tmp
rm -rf vasm
wget http://phoenix.owl.de/tags/vasm.tar.gz
tar zxvf vasm.tar.gz
cd vasm
make CPU=x86 SYNTAX=oldstyle
sudo cp vasmx86_oldstyle /usr/local/bin
make CPU=x86 SYNTAX=std
sudo cp vasmx86_std /usr/local/bin
