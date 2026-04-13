{ config, pkgs, ...}:

{
    programs.firefox = {
        enable = true;
        package = pkgs.librewolf;
        policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            Preferences = {
                "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
                "cookiebanners.service.mode" = 2; # Block cookie banners
                "privacy.donottrackheader.enabled" = true;
                "privacy.fingerprintingProtection" = true;
                "privacy.resistFingerprinting" = true;
                "privacy.trackingprotection.emailtracking.enabled" = true;
                "privacy.trackingprotection.enabled" = true;
                "privacy.trackingprotection.fingerprinting.enabled" = true;
                "privacy.trackingprotection.socialtracking.enabled" = true;
                "privacy.resistFingerprinting.letterboxing" = true;
            };
            ExtensionSettings = {
                #Bitwarden
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                    installation_mode = "force_installed";
                };
                "jid1-ZAdIEUB7XOzOJw@jetpack" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
                    installation_mode = "force_installed";
                };
                "uBlock0@raymondhill.net" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    installation_mode = "force_installed";
                };
                "plasma-browser-integration@kde.org" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
                    installation_mode = "force_installed";
                };
                #Spoof Timezone
                "{55f61747-c3d3-4425-97f9-dfc19a0be23c}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/spoof-timezone/latest.xpi";
                    installation_mode = "force_installed";
                };
            };
        };
    };

    environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
}