let
  unstable = import ../../system/nixpkgs/unstable.nix;
  release-21-05 = import ../../system/nixpkgs/21.05.nix;
in
self: super: {
  unstable = import unstable { config = super.config; };
  release-21-05 = import release-21-05 { config = super.config; };
}
