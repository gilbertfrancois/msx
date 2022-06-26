#!/usr/bin/env bash

CWD=`pwd`
cd /tmp
wget https://pasmo.speccy.org/bin/pasmo-0.5.5.tar.gz
rm -rf pasmo-0.5.5
tar zxvf pasmo-0.5.5.tar.gz
cd pasmo-0.5.5
export CXXFLAGS="-std=c++17"
./configure
make
sudo make install
cd ${CWD}
