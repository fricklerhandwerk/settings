{ pkgs, ... }:
let
  mount-afp = pkgs.writeScriptBin "mount-afp" (builtins.readFile ./mount-afp.fish);
in
{
  home.packages = [ mount-afp ];
}
