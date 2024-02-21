#!/bin/bash
set -e

sudo apt-get -y install git build-essential cmake

if [ -d "slang" ]; then
  rm -rf slang
fi

git clone https://github.com/MikePopoloski/slang.git

cd slang

cmake -B build
cmake --build build -j$(nproc)

sudo cmake --install build --prefix=/usr/local



