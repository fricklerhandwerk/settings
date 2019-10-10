let
  nixpkgs = import ./nixpkgs.nix;
  configuration = { pkgs, ... }: {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ];
    environment.systemPackages = with pkgs; [ git neovim ];
  };
  nixos = import "${nixpkgs}/nixos" {
    inherit configuration;
  };
in
nixos.config.system.build.isoImage
