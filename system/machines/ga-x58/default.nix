{ config, ... }:
{
  imports = [
    ../../common
    ../../common/local.nix
    ../../common/x11.nix
    ./hardware.nix
    ./boot.nix
  ];

  services.xserver = {
    videoDriver = "nvidiaLegacy390";
  };

  networking.enableB43Firmware = true;
  hardware.pulseaudio.enable = true;
}
