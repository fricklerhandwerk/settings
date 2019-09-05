{ config, pkgs,  ... }:
{
  imports = [
    ../default.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
    videoDriver = "nvidiaLegacy390";
  };
  i18n.consoleUseXkbConfig = true;

  # use closed-source drivers
  nixpkgs.config.allowUnfree = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;
}
