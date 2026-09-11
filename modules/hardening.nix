{ }:

{
	security = {
		doas.enable = true;
		doas.extraRules = [{
			users = ["rommelvj"];
			keepEnv = true;
			persist = true;
		}];
		sudo.enable = false;
	};
}
