{ config, pkgs, ... }:
with config;
{
  imports = [
    ../modules/home-config.nix
  ];
  system.stateVersion = "19.03";
  # having the date of the revision would be nice, but `builtins.fetchGit` does
  # not export that attribute and there is no other meaningful way to get it
  # without re-fetching a significant portion of the repository
  system.nixos.versionSuffix = "-${(import ./nixpkgs.nix).shortRev}";

  nix.nixPath = [
    # NOTE: updated values are only available on a fresh user session
    "nixpkgs=${(import ./nixpkgs.nix)}"
    # XXX: spell out the filename for `nixos-rebuild edit` to work
    "nixos-config=${toString ../machines}/${networking.hostName}/default.nix"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  # resolve `.local` domains
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online = {
    wantedBy = [ "network-online.target" ];
  };

  programs.fish.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';
}
