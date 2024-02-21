#!/bin/bash
set -e

sudo apt-get -y install git build-essential libssl-dev \
                        libmpfrc++-dev libmpc-dev libgmp-dev \
                        gcc-multilib

if [ -d "CMake" ]; then
  rm -rf CMake
fi

git clone https://github.com/Kitware/CMake.git

cd CMake

git checkout release

./configure --prefix=/usr/local

make -j$(nproc)
sudo make install

cd -

if [ -d "gcc" ]; then
  rm -rf gcc
fi

git clone https://gcc.gnu.org/git/gcc.git

cd gcc

git checkout remotes/origin/releases/gcc-13

./configure --prefix=/usr/local --enable-languages=c,c++

make -j$(nproc)
sudo make install

cd -

if [ -d "slang" ]; then
  rm -rf slang
fi

git clone https://github.com/MikePopoloski/slang.git

cd slang

cmake -B build
cmake --build build -j$(nproc)

sudo cmake --install build --prefix=/usr/local



