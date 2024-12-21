#!/bin/bash
set -e

sudo apt-get -y install git help2man perl python3 make autoconf g++ flex bison ccache \
                        libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev \
                        zlib1g zlib1g-dev

if [ -d "$BASEDIR/tools/verilator" ]; then
  rm -rf $BASEDIR/tools/verilator
fi

git clone https://github.com/verilator/verilator.git $BASEDIR/tools/verilator

unset VERILATOR_ROOT

cd $BASEDIR/tools/verilator

git pull
git checkout stable

autoconf
./configure --prefix=/usr/local

make -j$(nproc)
sudo make install
