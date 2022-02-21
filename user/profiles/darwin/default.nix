{ pkgs, lib, ... }:
{
  imports = [
    ../common
    ../common/crypto
    ../common/kitty.nix
    ./fix-time-machine.nix
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;

  home.sessionPath = [
    # use wine from graphical installer
    "/Applications/Wine.app/Contents/Resources/wine/bin"
    # use `homebrew` for stuff that is not managed by `nix`
    "/usr/local/bin"
  ];

  home.packages = with pkgs; [
    umlet
    vscode
    (pkgs.callPackage ./nixos-rebuild.nix {})
  ];

  programs.fish = {
    # workaround to source the nix profile, which is written in `sh`.
    # see: # <https://github.com/nix-community/home-manager/blob/7e5fee4268f53be8758598b7634dff8b3ad8a22b/modules/programs/fish.nix#L346>
    shellInit = ''
      set -x NIX_PATH ~/.nix-defexpr/channels
      set -p fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      set -e fish_function_path[1]
    '';
  };
  # workaround for Bazel C builds on Darwin:
  # https://github.com/NixOS/nixpkgs/issues/150655
  home.file.".bazelrc".text = ''
    build --repo_env=BAZEL_CXXOPTS="-I${pkgs.libcxx.dev}/include/c++/v1"
  '';
}
