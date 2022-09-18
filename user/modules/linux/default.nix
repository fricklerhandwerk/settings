{ pkgs, ... }:
{
  imports = [
    ../.
    ./desktop-environment
    ./secrets.nix
    ./udiskie.nix
    ./mount-afp.nix
    ./ssh-agent.nix
  ];

  home.packages = with pkgs; [
    acpi
  ];

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
}
