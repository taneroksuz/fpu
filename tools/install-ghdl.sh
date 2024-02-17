#!/bin/bash
set -e

sudo apt-get -y install git build-essential llvm-dev make gnat clang zlib1g-dev

if [ -d "ghdl" ]; then
  rm -rf ghdl
fi

git clone https://github.com/ghdl/ghdl.git

cd ghdl

./configure --with-llvm-config --prefix=/usr/local

make -j$(nproc)
sudo make install
