# configuration for linux machines with human interface devices
{ pkgs, ... }:
{
  imports = [
    ../.
    ../../workstation
    ./ssh-agent.nix
  ];
}
