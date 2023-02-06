{ pkgs, ... }:
let
  nixpkgs = import ./nixpkgs.nix;
  home-manager = self: super: {
    home-manager = super.callPackage ./home-manager.nix { };
  };
  nixops = self: super: {
    nixos = import ./nixops.nix;
  };
  tor-browser = import ./tor-browser.nix;
  wine = import ./wine.nix;
  sigtop = self: super: {
    sigtop = super.callPackage ./sigtop.nix { };
  };
in
{
  nixpkgs.overlays = [
    nixpkgs
    home-manager
    nixops
    tor-browser
    sigtop
    wine
  ];
}
