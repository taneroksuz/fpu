#!/bin/bash
set -e

PREFIX=/opt/verilator

if [ -d "$PREFIX" ]
then
  sudo rm -rf $PREFIX
fi
sudo mkdir $PREFIX
sudo chown -R $USER:$USER $PREFIX/

sudo apt-get -y install git make autoconf g++ flex bison libfl-dev help2man

if [ -d "verilator" ]; then
  rm -rf verilator
fi

git clone http://git.veripool.org/git/verilator

unset VERILATOR_ROOT

cd verilator

git pull
git checkout stable

autoconf
./configure --prefix=$PREFIX

make -j$(nproc)
make install
