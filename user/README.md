# .config

On a machine with `nix` run

  ./install <machine>

to set up its respective home-manager configuration.

## goals

Primary objective is to configure all my userspace software through `home-manager` on both NixOS and macOS - replacing `homebrew`.

## to do

- pin nixpkgs version
- continuous backup to network storage (and retrieval)
- mail
- lock all logged-in sessions for a user on lid close
  - `phsylock` for terminal, `xsecurelock` for `X`
- iPhone backup/sync
- export `osxkeychain` passwords to `pass`

## nice to have

- custom xmobar icon pattern for battery status
- restart xmobar on wakeup
- custom greeter
- switch user on lock screen
- create minimal blog
- create minimal game with graphics (try godot engine)
