{ ... }:
{
  nix.maxJobs = 4;
  powerManagement.cpuFreqGovernor = "powersave";

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware.enableRedistributableFirmware = true;
}
