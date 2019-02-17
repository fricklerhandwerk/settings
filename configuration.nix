{ config, pkgs, ... }:
with builtins;
with pkgs;
{
  imports =
    [
      ./hardware-configuration.nix
      "${hmsrc}/nixos"
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    home-manager
  ];

  system.stateVersion = "18.09";
}
