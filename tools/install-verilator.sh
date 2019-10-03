#!/bin/bash

INST_PATH=/opt/verilator

if [ -d "$INST_PATH" ]
then
  sudo rm -rf $INST_PATH
fi
sudo mkdir $INST_PATH
sudo chown -R $USER $INST_PATH/

sudo apt-get install git make autoconf g++ flex bison libfl-dev

if [ -d "verilator" ]; then
  rm -rf verilator
fi

git clone http://git.veripool.org/git/verilator

unset VERILATOR_ROOT

cd verilator

git pull
git checkout stable

autoconf
./configure --prefix=$INST_PATH

make -j$(nproc)
make install
