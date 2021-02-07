{ machine }:
let
  system = "x86_64-linux";
  version = (import ((import ./nixpkgs/20.09.nix) + "/nixos") {
    inherit system;
    configuration = machine;
  }).config.system.stateVersion;
  nixpkgs = import (import (./nixpkgs + "/${version}.nix")) { inherit system; };
  host = baseNameOf machine;
in
{
  network = {
    description = host;
    enableRollback = true;
    nixpkgs = nixpkgs;
  };
  "${host}" =
    { config, pkgs, ... }:
    {
      imports = [ machine ];
      deployment.targetHost = host;
      deployment.provisionSSHKey = false;
    };
}
