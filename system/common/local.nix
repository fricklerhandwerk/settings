{ ... }:
{
  # resolve `.local` domains
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}
