{ ... }:
{
  imports = [
    ../../common
    ./boot.nix
    ./hardware.nix
  ];

  services.openssh = {
    enable = true;
  };

  services.avahi = {
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.apcupsd = {
    enable = true;
    configText = ''
      UPSTYPE usb
      BATTERYLEVEL 20
      MINUTES 2
      ANNOY 20
      ANNOYDELAY 20
    '';
  };
}
