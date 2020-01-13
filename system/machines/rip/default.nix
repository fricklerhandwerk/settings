{ ... }:
{
  imports = [
    ../../common
    # this is a VPS, hardware and network are auto-generated
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/network-configuration.nix
  ];

  boot.cleanTmpDir = true;

  security.pam.services.su.requireWheel = true;
  services.openssh.enable = true;
  networking.firewall.allowPing = true;
}
