#!/usr/bin/env bash
set -e

sudo apt-get update
sudo apt-get install -y python3 python3-pip pipx

pipx ensurepath
pipx install vsg --force