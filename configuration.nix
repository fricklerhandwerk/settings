{ config, pkgs, ... }:
with builtins;
with pkgs;
let
  home-manager = import (
    fetchTarball https://github.com/rycee/home-manager/archive/release-18.09.tar.gz
    ) { inherit pkgs; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      home-manager.nixos
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    home-manager.home-manager
  ];

  system.stateVersion = "18.09";
}
