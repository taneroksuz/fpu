#!/bin/bash

INST_PATH=/opt/testfloat

if [ -d "$INST_PATH" ]
then
  sudo rm -rf $INST_PATH
fi
sudo mkdir $INST_PATH
sudo chown -R $USER $INST_PATH/

sudo apt-get -y install build-essential

if [ -d "berkeley-softfloat-3" ]
then
  rm -rf berkeley-softfloat-3
fi

if [ -d "berkeley-testfloat-3" ]
then
  rm -rf berkeley-testfloat-3
fi

git clone https://github.com/ucb-bar/berkeley-softfloat-3.git
git clone https://github.com/ucb-bar/berkeley-testfloat-3.git

cd berkeley-softfloat-3/build/Linux-x86_64-GCC
make -j$(nproc)

cd -

cd berkeley-testfloat-3/build/Linux-x86_64-GCC
make -j$(nproc)

mv -t $INST_PATH testfloat testfloat_gen testfloat_ver testsoftfloat timesoftfloat
