{ pkgs, lib, ... }:

{
	boot.initrd.systemd = {
		services.impermanence-btrfs-rolling-root = {
			description = "Archive existing BTRFS Root subvolume and create new one";
			
			unitConfig.DefaultDependencies = false;

			serviceConfig.Type = "oneshot";
			requiredBy = [ "initrd.target" ];
			before = [ "sysroot.mount" ];
			
			requires = [ "initrd-root-device.target" ];
			after = [
				"initrd-root-device.target"
				"local-fs-pre.target"
			];

			script = ''
				mkdir /btrfs_tmp
				mount /dev/disk/by-partlabel/root /btrfs_tmp
				if [[ -e /btrfs_tmp/root ]]; then
					mkdir -p /btrfs_tmp/old_roots
					timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+@%Y-%m-%-d_%H:%M:%S")
					mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
				fi
	
				delete_subvolume_recursively() {
					IFS=$'\n'
					for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
						delete_subvolume_recursively "/btrfs_tmp/$i"
					done
					btrfs subvolume delete "$1"
				}
	
				for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
					delete_subvolume_recursively "$i"
				done
	
				btrfs subvolume create /btrfs_tmp/root
				umount /btrfs_tmp
			'';
		};

		extraBin = {
			# "mkfs.ext4" = "${pkgs.e2fsprogs}/bin/mkfs.ext4";
         		"mkdir" = "${pkgs.coreutils}/bin/mkdir";
		        "date" = "${pkgs.coreutils}/bin/date";
		        "stat" = "${pkgs.coreutils}/bin/stat";
		        "mv" = "${pkgs.coreutils}/bin/mv";
		        "find" = "${pkgs.findutils}/bin/find";
		        "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
          		# mount & umount already exist
		};
	};

	environment.persistence."/nix/persist" = {
		hideMounts = true;
		directories = [
			"/etc/nixos"
			"/etc/NetworkManager/system-connections"
			"/etc/wpa_supplicant"
			"/etc/ssl/certs/eduroam"
			"/var/spool"
			"/var/lib/alsa"
			"/var/lib/bluetooth"
			#"/var/lib/cni"
			#"/var/lib/containers"
			"/var/lib/cloudflare-warp"
			"/var/lib/cups"
			"/var/lib/flatpak"
			"/var/lib/libvirt"
			"/var/lib/nixos"
			"/var/lib/qemu"
			"/var/lib/sddm"
			"/var/lib/systemd"
			"/var/lib/tailscale"
			"/var/lib/waydroid"
			"/var/log"
			"/root/.ssh"
		];
		files = [
			"/etc/machine-id"
			"/root/.config/sops/age/keys.txt"
		];
	};
}
