{ config, pkgs, ... }:
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
    # TODO: this may not be smart after all. maybe there should be a level of
    # indirection in between, just as for `nixos-config`. and then there is no
    # need to have a `./nixos/default.nix` any more. `nixos-rebuild` would work
    # off `$NIX_PATH`, and the installation script can have the right variables
    # set explicitly.
    "nixpkgs=${(import ./nixpkgs.nix)}"
    # XXX: spell out the filename for `nixos-rebuild edit` to work
    "nixos-config=${toString ../machines}/${config.networking.hostName}/default.nix"
  ];

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
