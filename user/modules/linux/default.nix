{ pkgs, ... }:
{
  imports = [
    ../.
    ./desktop-environment
    ./udiskie.nix
    ./mount-afp.nix
    ./ssh-agent.nix
    ./wine.nix
  ];

  home.packages = with pkgs;
  let
    tor-browser = unstable.tor-browser-bundle-bin.override
      { mediaSupport = true; };
  in [
    acpi
    qutebrowser
    vlc
    tor-browser
  ];

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
  xdg.enable = true;
}
