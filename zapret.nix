{ config, pkgs, lib, ... }:

{
	/*
	 * Before use in censored countries, run
	 * nix-shell -p zapret --command blockcheck
	 *for params that work with network
	 *
	 * For more information, visit
	 * nixkpgs search and search for "zapret" in the Options search
	 */

	services.zapret = {
		enable = true;
		package = pkgs.zapret;
		configureFirewall = true;
		httpMode = "first"; #first or full. Set to full if former doesn't work
		udpPorts = [
			"443"
			"53"
			"5060"
			"4500"
		];
	};

	environment.systemPackages = with pkgs; [
		zapret2
	];
}
