#!/usr/bin/env bash
# Get latest kernel PKGBUILD
readonly CACHEDIR=/home/eddy/cache
readonly DIR=$CACHEDIR/linux-tkg

git clone https://github.com/Frogging-Family/linux-tkg.git "$DIR"
cp customization.cfg "$DIR/customization.cfg"
cd "$DIR"

# Build

$CACHEDIR/build.sh

# Clean

cd "$CACHEDIR"
rm -rf "$DIR"
