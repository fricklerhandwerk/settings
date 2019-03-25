{ config, pkgs,  ... }:
with config;
{
  imports = [
    ../modules/home-config.nix
  ];
  system.stateVersion = "18.09";

  environment.systemPackages = with pkgs; [
    neovim
    git
    home-manager
  ];
}
