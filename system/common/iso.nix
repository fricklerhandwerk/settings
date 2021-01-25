let
  nixpkgs = import ../nixpkgs/20.09.nix;
  configuration = { pkgs, ... }: {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ];
    # TODO: since system configurations now live in a password-protected
    # repository, it is not possible any more to bootstrap a system by cloning
    # a public repository and executing a file from there.
    # alternative (not mutually exclusive) strategies:
    # 1. include installation script in installation image.
    #    downside: must have a priori access to the repository and build that
    #    image with `nix`. currently even necessarily from linux
    #    - configuration needs to be adapted for proper cross-build.
    # 2. host installation script publicly
    #    downside: needs a proper setup and `git` hook to keep public script up to date
    # 3. bundle script with secrets.
    #    downside: not part of the repository, cannot update automatically
    # 4. bundle secrets and script with image, host image publicly.
    #    downside: those of 1. and 2.
    #    advantage:  just `curl | dd` to a single USB stick and install.
    # in the first two cases we must rely on the availability of secrets (`gpg`
    # private key to decrypt `pass` entry). if installation script is included
    # in the image, secrets can also be part of the image. but probably this is
    # not preferable, as it in principle enables their proliferation. for these
    # strategies to be compatible with each other, the installation script
    # should expect to find the private key on a mounted external storage
    # device (as already implemented for user config).
    environment.systemPackages = with pkgs; [ git neovim ];
  };
  nixos = import "${nixpkgs}/nixos" {
    inherit configuration;
  };
in
nixos.config.system.build.isoImage
