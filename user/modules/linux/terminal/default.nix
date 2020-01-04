{ pkgs, ... }:
{
  imports = [
    ../.
    ../../terminal
    ./ssh-agent.nix
  ];
}
