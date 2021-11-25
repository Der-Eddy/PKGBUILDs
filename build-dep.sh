#!/bin/bash
set -e

CHROOT=/home/eddy/chroot
SRCDIR=/home/eddy/cache

repoctl down -o build-order.txt -r $1
for pkg in $(cat build-order.txt); do
    (
        cd "$pkg"
        arch-nspawn $CHROOT/root pacman --noconfirm --needed -Syu
        makechrootpkg -c -r $CHROOT -- --noconfirm --needed --syncdeps --skipinteg
        cd ..
        rm -rf "$pkg"
        repoctl update
    )
done
rm build-order.txt
 
