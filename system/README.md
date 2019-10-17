# nixos

## goals

Primary objective is to fully replace my macOS installations and the occasional Ubuntu with a fully reproducible NixOS.

## PRs

- nixos-hardware: add declarative option to README
- nixpkgs: user-actkbd (fix pulseaudio)
- nixpkgs: use `-I` values in `nixos-rebuild edit`
- nix: export revision date in `builtins.fetchGit`

## to do

- make system repo private (setup for easy installation, e.g. secrets in image or USB mount)
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
