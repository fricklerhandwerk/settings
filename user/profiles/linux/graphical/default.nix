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
    vscode
    wine
    winetricks
    unstable.discord
  ];
}
