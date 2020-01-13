{ ... }:
{
  imports = [
    ../../common
    ../../common/server.nix
    # this is a VPS, hardware and network are auto-generated
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/network-configuration.nix
  ];

  boot.cleanTmpDir = true;
}
