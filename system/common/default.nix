{ config, pkgs, ... }:
{
  imports = [
    ../modules/home-config.nix
  ];
  system.stateVersion = "20.09";

  nix.nixPath = [
    # NOTE: updated values are only available on a fresh user session
    # TODO: this should point to the mutable file, but it needs to be separately
    # deployed to the target machine when we manage it with NixOps. ideally we
    # would only copy the files actually needed for that machine.
    ''nixpkgs=${import (../nixpkgs + "/${config.system.stateVersion}.nix")}''
    # XXX: spell out the filename for `nixos-rebuild edit` to work
    "nixos-config=${toString ../machines}/${config.networking.hostName}/default.nix"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    ntfs3g
    # needed for `ssh` when using `kitty`
    kitty.terminfo
  ];

  networking.networkmanager.enable = true;
  # TODO: the bug where this line was missing is fixed in
  # 19.09 - remove when upgrading.
  systemd.services.NetworkManager-wait-online = {
    wantedBy = [ "network-online.target" ];
  };

  programs.fish.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';
}
