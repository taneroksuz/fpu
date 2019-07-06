#!/bin/bash

INST_PATH=/usr/local

sudo apt-get install git make autoconf g++ flex bison libfl-dev

if [ -d "verilator" ]; then
  rm -rf verilator
fi

git clone http://git.veripool.org/git/verilator

unsetenv VERILATOR_ROOT
unset VERILATOR_ROOT

cd verilator

git pull
git checkout stable

autoconf
./configure --prefix=$INST_PATH

make -j$(nproc)
sudo make install
