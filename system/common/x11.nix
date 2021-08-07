{ ... }:
{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  console.useXkbConfig = true;
  hardware.opengl.driSupport32Bit = true;
}
