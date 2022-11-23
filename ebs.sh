#!/bin/bash
set -e

readonly CHROOT=/home/eddy/chroot
readonly SRCDIR=/home/eddy/cache
readonly NTFY=https://ntfy.sh/archlinux-building

if [ "$1" == "build" ];
then
        repoctl down -o build-order.txt -r $2
elif [ "$1" == "update" ];
then
        repoctl down -u -o build-order.txt
fi
for pkg in $(cat build-order.txt); do
    (
        if [ "$pkg" == "esphome" ];
        then
            git clone https://aur.archlinux.org/esphomeyaml.git "$SRCDIR/esphome"
        fi
        if [ "$pkg" == "czkawka-cli" ] || [ "$pkg" == "czkawka-gui" ];
        then
            pkg="czkawka"
        fi
        curl -H "Title: 🔨 Building $pkg" -d "ongoing ..." $NTFY
        cd "$pkg"
        arch-nspawn $CHROOT/root pacman --noconfirm --needed -Syu
        if makechrootpkg -c -r $CHROOT -- --noconfirm --needed --syncdeps --skipinteg
        then
        repolog=$( repoctl update )
        curl -H "Title: ✔️ Finished $pkg" -d "$repolog" $NTFY
        echo $repolog
        else
        curl -H "Title: ❌ Failed $pkg" -d "log" $NTFY
        fi
        cd ..
        if [ "$pkg" == "esphome" ];
        then
            rm -rf "$SRCDIR/esphome"
        fi
        rm -rf "$pkg"
    )
done
rm build-order.txt
