{ ... }:
{
  # no passwords for users which are not declared here
  users.mutableUsers = false;
  # sudo through SSH - without password prompt
  # NOTE: set in your ` ~/.ssh/config` for the target machine:
  #     ForwardAgent: yes
  security.pam.enableSSHAgentAuth = true;
  security.pam.services.sudo.sshAgentAuth = true;
  # changing users can only be done by sudoers
  security.pam.services.su.requireWheel = true;

  networking.firewall.allowPing = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
  };
}
