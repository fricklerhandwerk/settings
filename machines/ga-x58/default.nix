{ config, pkgs,  ... }:
{
  imports = [
    ../default.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  i18n.consoleUseXkbConfig = true;

  hardware.pulseaudio.enable = true;

  # install closed-source drivers for broadcom WLAN adapter
  nixpkgs.config.allowUnfree = true;
}
