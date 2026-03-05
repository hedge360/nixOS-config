{ config, pkgs, ... }:

{
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "rommelvj" ];

    virtualisation.libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
        };
    };

    virtualisation.spiceUSBRedirection.enable = true;

    systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

    boot.binfmt.emulatedSystems = [
        "aarch64-linux"
        "riscv64-linux"
    ];

    virtualisation.docker = {
        enable = true;
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };
}