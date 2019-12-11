{ config, lib, pkgs, ... }:
{
  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = "powersave";

  boot = {
    initrd.availableKernelModules = [
      "uhci_hcd"
      "ehci_pci"
      "ahci"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };
}
