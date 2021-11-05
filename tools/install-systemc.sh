#!/bin/bash

INST_PATH=/opt/systemc

if [ -d "$INST_PATH" ]
then
  sudo rm -rf $INST_PATH
fi
sudo mkdir $INST_PATH
sudo chown -R $USER $INST_PATH/

if [ -d "systemc-2.3.3" ]; then
  rm -rf systemc-2.3.3
fi

wget https://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.tar.gz
tar -xf systemc-2.3.3.tar.gz

cd systemc-2.3.3

./configure --prefix=$INST_PATH
make -j$(nproc)
make install
