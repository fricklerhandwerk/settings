{ ... }:
{
  networking.firewall.allowPing = true;
  services.openssh.enable = true;
  security.pam.services.su.requireWheel = true;
}
