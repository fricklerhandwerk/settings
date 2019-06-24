{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pass
    gnupg
  ];
  services.gpg-agent.enable = true;
}
