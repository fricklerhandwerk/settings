{ config, lib, pkgs, utils,  ... }:
with pkgs;
let
  users = config.users.users;
  home-config = { lib, ... }: {
    options.config = with lib; mkOption {
      description = "user's home configuration repository";
      default = null;
      type = with types; nullOr (submodule ({config, ...}: {
        options = {
          fetch = mkOption {
            type = str;
            description = "fetch URL for git repository with user configuration";
          };
          push = mkOption {
            type = str;
            default = config.fetch;
            description = "push URL for git repository, if it differs";
          };
          branch = mkOption {
            type = str;
            default = "master";
            description = "branch in repository to clone";
          };
          path = mkOption {
            type = str;
            default = ".config";
            description = "clone path for configuration repository, relative to user's $HOME";
          };
          install = mkOption {
            type = str;
            default = "./install";
            description = "installation command";
          };
        };
      }));
    };
  };
in
{
  options = with lib; with types; {
    users.users = mkOption {
      type = attrsOf (submodule home-config);
    };
  };
  config = with builtins; with lib;
    let
      check = user: "home-config-check-${utils.escapeSystemdPath user.name}";
      initialise = user: "home-config-initialise-${utils.escapeSystemdPath user.name}";
      service = unit: "${unit}.service";
    in {
    # set up user configuration before first login
    systemd.services = mkMerge (map (user: mkIf (user.isNormalUser && user.config != null) {
      # skip initialisation early on boot, before waiting for the network, if
      # git repository appears to be in place.
      "${check user}" = {
        description = "check home configuration for ${user.name}";
        wantedBy = [ "multi-user.target" ];
        unitConfig = {
          # path must be absolute!
          # <https://www.freedesktop.org/software/systemd/man/systemd.unit.html#ConditionArchitecture=>
          ConditionPathExists = "!${user.home}/${user.config.path}/.git";
        };
        serviceConfig = {
          User = user.name;
          SyslogIdentifier = check user;
          # systemd docs say that not specifying `Type` and `ExecStart` implies
          # `Type=oneshot`, but in reality it still complains if `ExecStart` is
          # not defined, even if `Type=oneshot` is explicitly set.
          # <https://www.freedesktop.org/software/systemd/man/systemd.service.html#Type=>
          Type = "oneshot";
          ExecStart = "${coreutils}/bin/true";
        };
      };
      "${initialise user}" = {
        description = "initialise home-manager configuration for ${user.name}";
        # do not allow login before setup is finished. after first boot the
        # process takes a long time, and the user would log into a broken
        # environment.
        # let display manager wait in graphical setups.
        wantedBy = [ "multi-user.target" ];
        before = [ "systemd-user-sessions.service" ] ++ optional config.services.xserver.enable "display-manager.service";
        # `nix-daemon` and `network-online` are required under the assumption
        # that installation performs `nix` operations and those usually need to
        # fetch remote data
        after = [ (service (check user)) "nix-daemon.socket" "network-online.target" ];
        bindsTo = [ "nix-daemon.socket" "network-online.target" ];
        requires = [ (service (check user)) ];
        path = [
          git
          nix # for nix-shell
        ];
        environment = {
          NIX_PATH = builtins.concatStringsSep ":" config.nix.nixPath;
        };
        serviceConfig = {
          User = user.name;
          Type = "oneshot";
          SyslogIdentifier = initialise user;
          ExecStart = let
            script = writeShellScriptBin (initialise user) ''
              set -e
              mkdir -p ${user.home}/${user.config.path}
              cd ${user.home}/${user.config.path}
              git init
              git remote add origin ${user.config.fetch}
              git remote set-url origin --push ${user.config.push}
              git fetch
              git checkout ${user.config.branch} --force
              ${user.config.install}
            ''; in "${script}/bin/${(initialise user)}";
          };
        };
      }) (attrValues config.users.users));

    # this is a user-specific requirement, but needs to be supported by the
    # system for fully-automatic bootstrapping *before* first login. not sure
    # what could be a good approach to deploying secrets except storing a PGP
    # private key locally (e.g. on a USB key) and mounting it for copying.
    # TODO: iterate over `users` and add permissions per user. there should be
    # a field in `home-config` to define a (list of) device(s) with certain
    # properties (such as file system UUID) and filter by those properties for
    # mounting.
    # polkit rule interface:
    # <https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html#polkit-rules>
    # udisks2 variables and actions:
    # <http://storaged.org/doc/udisks2-api/2.7.5/udisks-polkit-actions.html>
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        var permission = {
          "org.freedesktop.udisks2.filesystem-mount": "yes",
          "org.freedesktop.udisks2.filesystem-mount-other-seat": "yes",
        };
        if (subject.isInGroup("wheel")) {
          return permission[action.id];
        }
      });
    '';
  };
}
