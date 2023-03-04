#!/bin/bash

INST_PATH=/opt/ghdl

if [ -d "$INST_PATH" ]
then
  sudo rm -rf $INST_PATH
fi
sudo mkdir $INST_PATH
sudo chown -R $USER $INST_PATH/

sudo apt-get -y install git build-essential llvm-dev make gnat clang

if [ -d "ghdl" ]; then
  rm -rf ghdl
fi

git clone https://github.com/ghdl/ghdl.git

cd ghdl

./configure --with-llvm-config --prefix=$INST_PATH

make -j$(nproc)
make install
