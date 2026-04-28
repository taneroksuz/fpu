#!/bin/bash
set -e

VERIBLE_VERSION="${VERIBLE_VERSION:-v0.0-4053-g89d4d98a}"
INSTALL_DIR="${1:-/usr/local/bin}"

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  ARCH_SUFFIX="x86_64" ;;
  aarch64) ARCH_SUFFIX="aarch64" ;;
  *)
    echo "ERROR: Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

echo "Installing Verible ${VERIBLE_VERSION} (${ARCH_SUFFIX}) ..."

TARBALL="verible-${VERIBLE_VERSION}-linux-static-${ARCH_SUFFIX}.tar.gz"
URL="https://github.com/chipsalliance/verible/releases/download/${VERIBLE_VERSION}/${TARBALL}"

TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

curl -fL --progress-bar "$URL" -o "$TMP_DIR/$TARBALL"
tar -xzf "$TMP_DIR/$TARBALL" -C "$TMP_DIR"

BIN_DIR=$(find "$TMP_DIR" -mindepth 2 -maxdepth 2 -name bin -type d | head -1)
if [ -z "$BIN_DIR" ]; then
  echo "ERROR: Could not locate bin/ directory in tarball"
  exit 1
fi

sudo install -m 755 "$BIN_DIR"/verible-* "$INSTALL_DIR"

echo "Done. Installed binaries to $INSTALL_DIR:"
ls "$INSTALL_DIR"/verible-*