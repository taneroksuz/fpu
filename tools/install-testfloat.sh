#!/bin/bash
set -e

sudo apt-get -y install git build-essential make

if [ -d "$BASEDIR/tools/berkeley-softfloat-3" ]
then
  rm -rf $BASEDIR/tools/berkeley-softfloat-3
fi

if [ -d "$BASEDIR/tools/berkeley-testfloat-3" ]
then
  rm -rf $BASEDIR/tools/berkeley-testfloat-3
fi

git clone https://github.com/ucb-bar/berkeley-softfloat-3.git $BASEDIR/tools/berkeley-softfloat-3
git clone https://github.com/ucb-bar/berkeley-testfloat-3.git $BASEDIR/tools/berkeley-testfloat-3

cd $BASEDIR/tools/berkeley-softfloat-3/build/Linux-x86_64-GCC
make -j$(nproc)

cd $BASEDIR/tools/berkeley-testfloat-3/build/Linux-x86_64-GCC
make -j$(nproc)

sudo mv -t /usr/local/bin testfloat testfloat_gen testfloat_ver testsoftfloat timesoftfloat

sudo chmod +x /usr/local/bin/testfloat
sudo chmod +x /usr/local/bin/testfloat_gen
sudo chmod +x /usr/local/bin/testfloat_ver
sudo chmod +x /usr/local/bin/testsoftfloat
sudo chmod +x /usr/local/bin/timesoftfloat
