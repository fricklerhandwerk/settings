{ config, pkgs, lib, ... }:
# pin NixOS version declaratively by letting `nixos-rebuild` call into our own
# entry point for `<nixpkgs/nixos>`. for details see
# <https://github.com/NixOS/nixpkgs/issues/62832#issuecomment-531008247>.
let
  machine = config.networking.hostName;
  configuration = "${toString ../machines}/${machine}";
  # the content of this file would be the same for every machine if we would
  # place it into each machine's directory; it would import the same relative
  # file names. also currently `nixos` lives in the same repository as
  # `nixpkgs`.  therefore we cannot point `nixos-rebuild` directly to
  # `$machine`, as it is looking for `$machine/nixos`, and this is annoying.
  # so we deduplicate and use impure references to files in this repository
  # instead. the downside is that it takes two rebuilds to change these
  # references and keep the `nixos-rebuild` wrapper working: first change
  # this file, then move the referenced files. but this should be a rare
  # occasion, and is a tradeoff for more overall convenience.
  # TODO: there is another variant which lets this file live in the repository:
  # use `<nixos-config>` as the reference inside the file and run
  # `nixos-rebuild -I nixos-config=$machine`. this bears some risk of confusion
  # because of the impure angle bracket reference, but clarifies the outward
  # interface, and allows for easy manual fallback.
  entry-point = pkgs.writeTextFile rec {
    name = machine;
    destination = "/nixos/default.nix";
    text = ''
      { ... }:
      let
        nixpkgs = import ${toString ./nixpkgs.nix};
        configuration = ${configuration};
      in
      import "''${nixpkgs}/nixos" { inherit configuration; }
    '';
    checkPhase = ''
      # `nix` within `nix` needs a special environment
      export NIX_STATE_DIR=$TMPDIR
      ${config.nix.package}/bin/nix-instantiate --parse $out/${destination} > /dev/null
    '';
  };
  # this is the same as copying the original file, since that script tries to
  # read `.git`, which does not exist in the result of `fetchGit`, so it would
  # just as well output nothing.
  # TODO: working against `nixos-rebuild` internals is insane. instead try to
  # override `nixos.lib.versionSuffix`
  version-suffix = pkgs.writeTextFile {
    name = "nixos-version";
    destination = "/nixos/modules/installer/tools/get-version-suffix";
    text = "";
  };
  nixos = pkgs.symlinkJoin {
    name = machine;
    paths = [
      entry-point
      version-suffix
    ];
  };
in
{
  environment.systemPackages =
    let
      nixos-rebuild = pkgs.writeShellScriptBin "nixos-rebuild" ''
        # XXX: this should go through `-I nixos-config=`, but `nixos-rebuild`
        # does not use that value for `edit`
        export NIXOS_CONFIG=${configuration}/default.nix
        exec ${config.system.build.nixos-rebuild}/bin/nixos-rebuild -I nixpkgs=${nixos} "$@"
      '';
    in [ nixos-rebuild ];
}
