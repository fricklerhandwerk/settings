{ config, lib, pkgs, utils, ... }:
with lib;
with pkgs;
let
  # TODO: extend `config.users.users` to accomodate the new fields.
  users = config.home-config.users;
in
{
  options = {
    home-config.users = mkOption {
      description = "user's home config repository";
      type = types.attrsOf (types.submodule ({config, ...}: {
        options = {
          fetch = mkOption {
            type = types.str;
            description = "fetch URL for git repository with user configuration";
          };
          push = mkOption {
            type = types.str;
            default = config.fetch;
            description = "push URL for git repository, if it differs";
          };
          branch = mkOption {
            type = types.str;
            default = "master";
            description = "branch in repository to clone";
          };
          path = mkOption {
            type = types.str;
            default = ".config";
            description = "clone path for configuration repository, relative to user's $HOME";
          };
          install = mkOption {
            type = types.str;
            default = "install";
            description = "command to run in repository before login";
          };
        };
      }));
    };
  };
  config = {
    # run get user configuration on startup
    systemd.services = mkIf (users != { }) (
      let
        initialise = user: "home-config-init-${utils.escapeSystemdPath user}";
        check = user: "home-config-check-${utils.escapeSystemdPath user}";
        service = unit: "${unit}.service";
        home = user: config.users.users.${user}.home;
      in
      mapAttrs' (user: cfg: nameValuePair (check user) {
        description = "check home configuration for ${user}";
        wantedBy = [ "multi-user.target" ];
        unitConfig = {
          # path must be absolute!
          # <https://www.freedesktop.org/software/systemd/man/systemd.unit.html#ConditionArchitecture=>
          ConditionPathExists = "!${home user}/${cfg.path}/.git";
        };
        serviceConfig = {
          User = user;
          SyslogIdentifier = check user;
          # systemd docs say that not specifying `Type` and `ExecStart` implies
          # `Type=oneshot`, but in reality it still complains if `ExecStart` is
          # not defined, even if `Type=oneshot` is explicitly set.
          # <https://www.freedesktop.org/software/systemd/man/systemd.service.html#Type=>
          Type = "oneshot";
          ExecStart = "${coreutils}/bin/true";
        };
      }) users //
      mapAttrs' (user: cfg: nameValuePair (initialise user) {
        description = "initialise home-manager configuration for ${user}";
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
        requires = [ (service (check user)) "nix-daemon.socket" "network-online.target" ];
        path = [ git ];
        serviceConfig = {
          User = user;
          Type = "oneshot";
          SyslogIdentifier = initialise user;
          ExecStart = let
            script = writeShellScriptBin (initialise user) ''
              set -e
              mkdir -p ${home user}/${cfg.path}
              cd ${home user}/${cfg.path}
              git init
              git remote add origin ${cfg.fetch}
              git remote set-url origin --push ${cfg.push}
              git fetch
              git checkout ${cfg.branch} --force
              ${home user}/${cfg.path}/${cfg.install}
            ''; in "${script}/bin/${(initialise user)}";
        };
      }) users);

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
