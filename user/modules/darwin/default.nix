{ pkgs, ... }:
{
  imports = [
    ../.
  ];

  home.packages = with pkgs; [
    kitty
  ];
}
