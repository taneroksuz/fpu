#!/bin/bash
set -e

PREFIX=/opt/systemc

if [ -d "$PREFIX" ]
then
  sudo rm -rf $PREFIX
fi
sudo mkdir $PREFIX
sudo chown -R $USER:$USER $PREFIX/

sudo apt-get -y install wget build-essential make

if [ -d "systemc-2.3.3" ]; then
  rm -rf systemc-2.3.3
fi

wget https://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.tar.gz
tar -xf systemc-2.3.3.tar.gz

cd systemc-2.3.3

./configure --prefix=$PREFIX
make -j$(nproc)
make install
