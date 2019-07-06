#!/bin/bash

INST_PATH=/usr/local

sudo apt-get -y install git build-essential zlib1g-dev gnat

if [ -d "ghdl" ]; then
  rm -rf "ghdl"
fi

git clone https://github.com/ghdl/ghdl.git

cd ghdl

./configure --prefix=$INST_PATH

make -j$(nproc)
sudo make install
