{ ... }:
{
  nix.maxJobs = 4;

  boot = {
    initrd.availableKernelModules = [
      "ehci_pci"
      "ahci"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };
}
