{ pkgs, ... }:
{
  imports = [
    ../.
    ../../common/kitty.nix
  ];

  home.packages = with pkgs; [
    qutebrowser
    qview
    tor-browser
    vlc
    wine
    winetricks
    unstable.discord
  ];
}
