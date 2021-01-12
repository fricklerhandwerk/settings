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

- boot NixOS image from USB
- format the installation disk appropriately[1]
  - make sure to use an `msdos` partition table for BIOS systems!
- mount the target file system under `/mnt`:
  
    sudo mount /dev/sda4 /mnt
    sudo mkdir -p /mnt/boot
    sudo mount /dev/sda2 /mnt/boot

- mount external storage with GPG private key to this repository

    sudo mkdir /usb
    sudo mount /dev/sdc1 /usb

- run `/usb/bootstrap <machine>` and respond to the GPG password prompt

Keep the external storage plugged in until logged in. After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.

[1]: Gentoo has a very extensive [manual](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#Default:_Using_parted_to_partition_the_disk) to partitioning and formatting. I prefer their GPT partition layout over that from the [NixOS manual](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning) as it allows easy switching of configurations both bootable on BIOS and UEFI systems.

# goals

Primary objective is to fully replace my macOS installations and the occasional Ubuntu with a fully reproducible NixOS.

