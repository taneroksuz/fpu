#!/bin/bash
set -e

sudo apt-get -y install git build-essential llvm-dev make gnat clang zlib1g-dev

if [ -d "$BASEDIR/tools/ghdl" ]; then
  rm -rf $BASEDIR/tools/ghdl
fi

git clone https://github.com/ghdl/ghdl.git $BASEDIR/tools/ghdl

cd $BASEDIR/tools/ghdl

./configure --with-llvm-config --prefix=/usr/local

make -j$(nproc)
sudo make install
