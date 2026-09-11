{ config, pkgs, ... }:

{
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "rommelvj" ];

    virtualisation.libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu;
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

    virtualisation.containers.enable = true;
    virtualisation.podman = {
	enable = true;
	dockerCompat = true;
	defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
	dive
	podman-tui
	docker-compose
	podman-compose
    ];
}
