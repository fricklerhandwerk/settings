{ pkgs, ... }:
{
  imports = [
    ../../modules
  ];

  machine = ./.;
}
