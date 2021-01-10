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
- format the installation disk appropriately[1] and mount the target file system under `/mnt`
- mount external storage with GPG private key to this repository
- run `$external/bootstrap` and respond to password prompts

Keep the external storage plugged in until logged in. After rebooting a user logging in should have its `home-manager` configuration active as specified in the `home-config` option.

[1]: Gentoo has a very extensive [manual](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#Default:_Using_parted_to_partition_the_disk) to partitioning and formatting. I prefer their GPT partition layout over that from the [NixOS manual](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning) as it allows easy switching of configurations both bootable on BIOS and UEFI systems.

# goals

Primary objective is to fully replace my macOS installations and the occasional Ubuntu with a fully reproducible NixOS.

