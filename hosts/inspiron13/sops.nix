{ ... }:

{
	sops = {
		defaultSopsFile = ../../.sops.yaml;
		age.sshKeyPaths = [];
		age.keyFile = "/home/rommelvj/.config/sops/age/keys.txt";
		
		secrets = {
			"wifi_password_hash" = {
				sopsFile = ../../secrets/wifi-password-hash.yaml;
				owner = "root";
				group = "root";
			};
		};
	};
}
