{ config, pkgs, ... }:
{
  imports = [
    ../../modules/machine.nix
    ../../overlays
    ./fish.nix
    ./git.nix
    ./nvim.nix
    ./zip.nix
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".text = pkgs.lib.generators.toPretty {} config.nixpkgs.config;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.sessionVariables = {
    # enter environment silently
    DIRENV_LOG_FORMAT="";
  };

  home.packages = with pkgs; [
    coreutils
    fd
    gnused
    htop
    less
    nixops
    ranger
    ripgrep
    rsync
    wget
    unstable.youtube-dl
    pandoc
    texlive.combined.scheme-medium
    emacs
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
  };
  home.sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin" ];
  xdg.enable = true;
}
