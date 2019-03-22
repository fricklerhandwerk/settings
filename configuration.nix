{ config, pkgs,  ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/home-config.nix
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
