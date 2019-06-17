{ config, pkgs,  ... }:
with config;
{
  imports = [
    ./hardware-configuration.nix
    ../modules/home-config.nix
  ];
  system.stateVersion = "18.09";

  environment.systemPackages = with pkgs; [
    neovim
    git
    pulseaudio-ctl
  ];

  # resolve `.local` domains
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  programs.fish.enable = true;
}
