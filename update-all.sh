 #!/bin/bash
set -e

CHROOT=/home/eddy/chroot
SRCDIR=/home/eddy/cache

repoctl down -u -o build-order.txt
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
