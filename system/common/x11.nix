{ ... }:
{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+fake";
    displayManager.session =
      let fakeSession = {
        manage = "window";
        name = "fake";
        start = "";
      }; in [ fakeSession ];
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  console.useXkbConfig = true;
  hardware.opengl.driSupport32Bit = true;
}
