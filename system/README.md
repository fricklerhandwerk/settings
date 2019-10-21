# nixos

set up a NixOS machine with complete configuration at first boot.

## custom image

Create an installation image on a system running `nix` and copy it to a USB stick:

    ./build-image
    > /nix/store/.../nixos-iso
    sudo dd if=/nix/store/.../nixos-iso/iso/nixos.iso of=/dev/sdX

## vanilla image

Download a NixOS installation image from <https://nixos.org/nixos/download.html> and `dd` it to a USB stick.

## bootstrapping

Boot from USB, format an installation partition [1] `/dev/sdXn` and run

    mount /dev/sdXn /mnt
    # custom image:
    git clone https://github.com/fricklerhandwerk/nixos
    # vanilla image:
    # nix-shell -p git --run "git clone https://github.com/fricklerhandwerk/nixos"
    nixos/install <machine>

After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.

[1]: Gentoo has a very extensive [manual](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#Default:_Using_parted_to_partition_the_disk) to partitioning and formatting. I prefer their GPT partition layout over that from the [NixOS manual](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning) as it allows easy switching of configurations both bootable on BIOS and UEFI systems.

# goals

Primary objective is to fully replace my macOS installations and the occasional Ubuntu with a fully reproducible NixOS.

## PRs

- nixos-hardware: add declarative option to README
- nixpkgs: user-actkbd (fix pulseaudio)
- nixpkgs: use `-I` values in `nixos-rebuild edit`
- nix: export revision date in `builtins.fetchGit`

## to do

- make system repo private (setup for easy installation, e.g. secrets in image or USB mount)
  - add gpg signing key to USB stick, `git-remote-gcrypt` needs it
  - write instructions to boostrap from encrypted repository
- hardware-configuration under version control
- slimmer interface to home-config (extend `user.users`)
- hard disk partitioning/formatting as part of installation script
- add system closure to installation image (reduce time to first boot)
- include `home-manager` packages in installation image (reduce time to first login)
- include secrets in installation image
- full machine image from configuration (`dd` to target disk and run)
- separate repositories for machine and user config
- notify on low battery
- hibernate on critical battery
- hibernate after suspend
- encrypted system partition
- add home server to machine pool
- add remote server to machine pool
- manage machines with NixOps
