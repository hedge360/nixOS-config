{ pkgs, inputs, config, ... }:

{
	imports = [ inputs.sops-nix.nixosModules.sops ];

	sops = {
		defaultSopsFile = ../../.sops.yaml;
		age.sshKeyPaths = [];
		age.keyFile = "/nix/persist/root/.config/sops/age/keys.txt";
		
		secrets = {
			"thinkpad-wifi-keypass.env" = {
				sopsFile = ../../secrets/thinkpad-wifi-keypass.yaml;
				owner = "root";
				group = "root";
				mode = "0400";
			};

			"hashed-password" = {
				sopsFile = ../../secrets/thinkpad-user-passwords.yaml;
				neededForUsers = true;
				owner = "root";
				group = "root";
				mode = "0400";
			};
		};
	};
}
