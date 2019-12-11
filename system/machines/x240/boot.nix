{ ... }:
{
  boot = {
    plymouth.enable = true;
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
        extraConfig = ''
          set timeout_style=hidden
        '';
        # an image is drawn even if the menu is skipped
        splashImage = null;
      };
    };
  };
}

