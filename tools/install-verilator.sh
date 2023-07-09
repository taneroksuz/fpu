#!/bin/bash
set -e

PREFIX=/opt/verilator

if [ -d "$PREFIX" ]
then
  sudo rm -rf $PREFIX
fi
sudo mkdir $PREFIX
sudo chown -R $USER:$USER $PREFIX/

sudo apt-get -y install git help2man perl python3 make autoconf g++ flex bison ccache \
                        libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev \
                        zlib1g zlib1g-dev

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
