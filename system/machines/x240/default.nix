{ config, ... }:
{
  imports = [
    ../../common
    ../../common/local.nix
    ../../common/x11.nix
    ./boot.nix
    ./audio.nix
    ./backlight.nix
    ./hardware.nix
    ./thinkpad.nix
  ];

  # FIXME: from 20.03 we can actually "suspend-then-hibernate"
  services.logind.lidSwitch = "hibernate";
  # FIXME: from 20.03 we can use `systemd.sleep.extraConfig` here
  environment.etc."systemd/sleep.conf".text = ''
    HibernateDelaySec=20
  '';
}
