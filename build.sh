#!/bin/bash

CHROOT=/home/eddy/chroot
SRCDIR=/home/eddy/cache

# Create new clean chroot

if [ ! -d "$CHROOT" ]; then
	mkdir $CHROOT
	mkarchroot -C $SRCDIR/pacman.conf -M $SRCDIR/makepkg.conf $CHROOT/root base-devel
	arch-nspawn $CHROOT/root pacman --noconfirm --needed -Syu ccache git jre-openjdk gconf python-setuptools
fi

# Build
makechrootpkg -c -r $CHROOT -- --noconfirm --needed --syncdeps

# Add to repository
repoctl update
