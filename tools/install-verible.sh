#!/bin/bash
set -e

sudo apt-get -y install git build-essential openjdk-11-jdk python-is-python3 zip unzip

if [ -d "$BASEDIR/tools/bazel" ]; then
  rm -rf $BASEDIR/tools/bazel
fi

if [ -f "$BASEDIR/tools/bazel.zip" ]; then
  rm -f $BASEDIR/tools/bazel.zip
fi

wget https://github.com/bazelbuild/bazel/releases/download/7.0.2/bazel-7.0.2-dist.zip -O $BASEDIR/tools/bazel.zip

unzip $BASEDIR/tools/bazel.zip -d $BASEDIR/tools/bazel

cd $BASEDIR/tools/bazel

env EXTRA_BAZEL_ARGS="--tool_java_runtime_version=local_jdk" bash ./compile.sh

sudo cp output/bazel /usr/local/bin/

cd $BASEDIR/tools/

if [ -d "$BASEDIR/tools/verible" ]; then
  rm -rf $BASEDIR/tools/verible
fi

git clone https://github.com/chipsalliance/verible.git $BASEDIR/tools/verible

cd $BASEDIR/tools/verible

bazel build -c opt :install-binaries

sudo .github/bin/simple-install.sh /usr/local/bin
