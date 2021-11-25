# EBS - Eddy Build System
---

This repository consists of two major parts: Arch building scripts and my system config in `system-config` which can be build into a package to pull dependencies I want.  
Everything is only tested on Arch Linux.
Packages are build with `-march=x86-64-v3` for better performance, but will only work with CPUs which are as old as Intel Haswell or newer.

Building Scripts
-------------

These will build packages for my unofficial Arch Linux repository located at https://archlinux.eddy-dev.net  
The package database is managed by [repoctl](https://github.com/cassava/repoctl).

There are several building scripts available:
    
 - `build.sh` will create a clean chroot environment, install needed tools and build **one** package based on PKGBUILD files.
 - `build-dep.sh` will take one argument i.e. `./build-dep.sh jekyll` and will build all dependencies from the AUR which are needed based on a `build-order.txt` file
 - `update-all.sh` will update all potential updates from the AUR based on a `build-order.txt` file determined by repoctl in one loop, you can check updates beforehand via `repoctl status -a`
 - `build-tkg.sh` will build custom linux kernel based on the [tkg kernel by TK-Glitch](https://github.com/Frogging-Family/linux-tkg) for skylake/kabylake and zen/zen+ CPUs.

Finally all of them will update the repository databse with `repoctl update`

System configs
-------------

Packages starting with system-\* are system configs for my own systems which for example install commonly used packages or set up system configs like `localtime` or `locale`.
