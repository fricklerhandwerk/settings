{ config, pkgs,  ... }:
{
  imports = [
    ../../common
    # TODO: add hardware configuration
  ];

  boot = {
    plymouth.enable = true;
    loader = {
      grub = {
        # an image is drawn even if the menu is skipped
        splashImage = null;
        extraConfig = ''
          if keystatus ; then
            if keystatus --alt ; then
              set timeout=-1
            else
              set timeout=0
            fi
          fi
        '';
      };
    };
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
    videoDriver = "nvidiaLegacy390";
  };
  i18n.consoleUseXkbConfig = true;

  # use closed-source drivers
  nixpkgs.config.allowUnfree = true;
  networking.enableB43Firmware = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;
}
