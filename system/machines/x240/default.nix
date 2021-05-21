{ config, ... }:
{
  imports = [
    ../../common
    ../../common/local.nix
    ../../common/x11.nix
    ./boot.nix
    ./audio.nix
    ./backlight.nix
    ./hardware.nix
    ./thinkpad.nix
  ];

  services.logind.lidSwitch = "hibernate";
}
