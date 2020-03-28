# EBS - Eddy Build System
---

This repository consists of two major parts: Arch building scripts and my system config in `system-config` which can be build into a package to pull dependencies I want.  
Everything is only tested on Arch Linux.

Building Scripts
-------------

These will build packages for my unofficial Arch Linux repository located at https://archlinux.eddy-dev.net  
The package database is managed by [repoctl](https://github.com/cassava/repoctl).

Mainly located in `build.sh` will create a clean chroot environment, install needed tools and build a package based on PKGBUILD files. Finally it will update the repository databse with `repoctl update`

`build-tkg.sh` will build custom linux kernel based on the [tkg kernel by TK-Glitch](https://github.com/Frogging-Family/linux-tkg) for skylake/kabylake and zen/zen+ CPUs.

System configs
-------------

Packages starting with system-\* are system configs for my own systems which for example install commonly used packages or set up system configs like `localtime` or `locale`.
