{ pkgs, inputs, ... }:

{
	home-manager.users.rommelvj = {
		imports = [
			inputs.caelestia.homeModules.default
		];
	};
}
