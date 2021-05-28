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
    ./trackpad.nix
  ];

  services.logind.lidSwitch = "hibernate";
}
