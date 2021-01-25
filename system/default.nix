# pin NixOS version declaratively by letting `nixos-rebuild` call into this
# custom entry point for `<nixpkgs/nixos>`. for details see
# <https://github.com/NixOS/nixpkgs/issues/62832#issuecomment-531008247>.

# ideally this would be the *only* entry point to each machine, but then
# 1) this file is the same everywhere, as it imports the same relative paths
# 2) since `nixos` lives in the same repository as `nixpkgs`, and
#    `nixos-rebuild` searches `<nixpkgs/nixos>`, we have to point it at
#    `machines/$machine/nixos`, which is annoying. that is also why this file
#    lives at the toplevel and the repository around it is conveniently named
#    `nixos` (only slightly less annoying).

{
  system ? builtins.currentSystem
, configuration ? <nixos-config>
, ...
}:
let
  version = (import <nixpkgs/nixos> { inherit system configuration; }).config.system.stateVersion;
in
import ''${import (./nixpkgs + "/${version}.nix")}/nixos'' { inherit system configuration; }
