#!/bin/bash
set -e

PREFIX=/opt/ghdl

if [ -d "$PREFIX" ]
then
  sudo rm -rf $PREFIX
fi
sudo mkdir $PREFIX
sudo chown -R $USER:$USER $PREFIX/

sudo apt-get -y install git build-essential llvm-dev make gnat clang zlib1g-dev

if [ -d "ghdl" ]; then
  rm -rf ghdl
fi

git clone https://github.com/ghdl/ghdl.git

cd ghdl

./configure --with-llvm-config --prefix=$PREFIX

make -j$(nproc)
make install
