{ config, pkgs, ... }:
with config;
{
  imports = [
    ./hardware-configuration.nix
    ../modules/home-config.nix
  ];
  system.stateVersion = "19.03";

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  # resolve `.local` domains
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online = {
    wantedBy = [ "network-online.target" ];
  };

  programs.fish.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';
}
