{ config, pkgs, lib, ... }:
let
  machine = "${toString ../machines}/${config.networking.hostName}";
in
{
  environment.systemPackages =
    let
      nixos-rebuild = pkgs.writeShellScriptBin "nixos-rebuild" ''
        # XXX: this should go through `-I nixos-config=`, but `nixos-rebuild`
        # does not use that value for `edit`
        export NIXOS_CONFIG=${machine}/default.nix
        exec ${config.system.build.nixos-rebuild}/bin/nixos-rebuild -I nixpkgs=${toString ./.} -I nixos-config=${machine} "$@"
      '';
    in [ nixos-rebuild ];
}
