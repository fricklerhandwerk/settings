{ pkgs, lib, ... }:
# sometimes the trackpad does not work after wakeup from suspend or hibernate.
# workaround: reload the kernel module and restart the associated X device.
# it would be much more convenient if this automatically ran as a `systemd`
# service on wakeup, but it is too cumbersome to figure out how to properly
# connect to the X session to do this...
let
  repad = with pkgs; writeShellScriptBin "repad" ''
    # cycle trackpad driver
    set -e

    PATH=${with pkgs; lib.makeBinPath [ kmod xorg.xinput coreutils ]}

    id=$(xinput --list --id-only "Synaptics TM2749-001"       2>/dev/null || \
         xinput --list --id-only "SynPS/2 Synaptics TouchPad" 2>/dev/null )

    modprobe -r psmouse
    modprobe psmouse
    sleep 1
    xinput --enable $id
  '';
in
{
  environment.systemPackages = [ repad ];
}
