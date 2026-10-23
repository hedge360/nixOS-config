{ config, pkgs, ... }:

{
	services.flatpak = {
		enable = true;
		remotes = {
			"flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
		};
		packages = [
			"flathub:app/org.vinegarhq.Sober//stable"
			"flathub:app/pw.mmk.OpenFreebuds/x86_64/stable"
			"flathub:app/sh.ppy.osu//stable"
			#"flathub:app/us.zoom.Zoom//stable"
		];
		runWithoutGui = false;
	};
}
