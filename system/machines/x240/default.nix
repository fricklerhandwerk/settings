{ config, ... }:
{
  imports = [
    ../../common
    ../../common/local.nix
    ./boot.nix
    ./audio.nix
    ./backlight.nix
    ./hardware.nix
    ./thinkpad.nix
  ];

  services.logind.lidSwitch = "hibernate";

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  i18n.consoleUseXkbConfig = true;
  hardware.opengl.driSupport32Bit = true;
}
