{ config, pkgs, ... }:

{
    #modules = [ arion.nixosModules.arion ];

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

    #docker
    virtualisation.docker = {
        enable = true;
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };

    /*
    virtualisation.arion = {
        enable = true;
        backend = "docker";
        projects = {
            "db".settings.services."db".service = {
                image = "";
                restart = "unless-stopped";
                environment = { POSTGRESS_PASSWORD = "password"; };
            };
        };
    };
    */
}