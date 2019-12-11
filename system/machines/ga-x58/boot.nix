{ ... }:
{
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
}
