#!/bin/bash
set -e

sudo apt-get -y install git build-essential openjdk-11-jdk python-is-python3 zip unzip

if [ -d "bazel" ]; then
  rm -rf bazel
fi

if [ -f "bazel-7.0.2-dist.zip" ]; then
  rm -f bazel-7.0.2-dist.zip
fi

wget https://github.com/bazelbuild/bazel/releases/download/7.0.2/bazel-7.0.2-dist.zip

unzip bazel-7.0.2-dist.zip -d bazel

cd bazel

env EXTRA_BAZEL_ARGS="--tool_java_runtime_version=local_jdk" bash ./compile.sh

sudo cp output/bazel /usr/local/bin/

cd -

if [ -d "verible" ]; then
  rm -rf verible
fi

git clone https://github.com/chipsalliance/verible.git

cd verible

bazel build --noenable_bzlmod -c opt //...

bazel run --noenable_bzlmod -c opt :install -- -s /usr/local/bin
