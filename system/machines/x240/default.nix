{ config, ... }:
{
  imports = [
    ../../common
    ../../common/local.nix
    ../../common/x11.nix
    ./boot.nix
    ./hardware.nix
    ./thinkpad.nix
    ./trackpad.nix
  ];

  services.logind.lidSwitch = "hibernate";
  hardware.pulseaudio.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
