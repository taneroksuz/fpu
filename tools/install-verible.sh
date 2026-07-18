#!/bin/bash
set -e

sudo apt-get update

sudo apt-get install -y curl tar

URL=$(curl -s https://api.github.com/repos/chipsalliance/verible/releases/latest | grep browser_download_url | grep linux-static-x86_64.tar.gz | cut -d '"' -f 4)
curl -L -o $BASEDIR/tools/verible.tar.gz "$URL"

mkdir -p $BASEDIR/tools/verible/
tar -xzf $BASEDIR/tools/verible.tar.gz -C $BASEDIR/tools/verible --strip-components=1

sudo cp -r $BASEDIR/tools/verible/bin/* /usr/local/bin/