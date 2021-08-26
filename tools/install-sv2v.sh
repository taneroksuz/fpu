#!/bin/bash

INST_PATH=/opt/sv2v

if [ -d "$INST_PATH" ]
then
  sudo rm -rf $INST_PATH
fi
sudo mkdir $INST_PATH
sudo chown -R $USER $INST_PATH/

curl -sSL https://get.haskellstack.org/ | sh

if [ -d "sv2v" ]; then
  rm -rf sv2v
fi

git clone https://github.com/zachjs/sv2v.git

cd sv2v

make -j$(nproc)

mkdir $INST_PATH/bin

cp bin/sv2v $INST_PATH/bin/
