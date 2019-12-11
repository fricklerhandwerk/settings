let
  nixos-hardware = builtins.fetchGit {
    url = https://github.com/NixOS/nixos-hardware;
    ref = "master";
  };
in
# there is no extra definition for x240
import "${nixos-hardware}/lenovo/thinkpad/x250"
