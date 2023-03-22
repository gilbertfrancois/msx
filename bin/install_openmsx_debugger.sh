#!/usr/bin/env bash

brew install qt@5


# export LDFLAGS="-L/usr/local/opt/qt@5/lib"
# export CPPFLAGS="-I/usr/local/opt/qt@5/include"
# export PKG_CONFIG_PATH="/usr/local/opt/qt@5/lib/pkgconfig"
# export PATH="/usr/local/opt/qt@5/bin:$PATH"
export PATH="/opt/homebrew/Cellar/qt@5/5.15.6/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/Cellar/qt@5/5.15.6/lib/pkgconfig"
export CPPFLAGS="-I/opt/homebrew/Cellar/qt@5/5.15.6/include"
export LDFLAGS-"-L/opt/homebrew/Cellar/qt@5/5.15.6/lib"

cd /tmp
git clone https://github.com/openMSX/debugger.git
cd debugger

make
sudo cp -r ./derived/openMSX_Debugger.app /Applications/
