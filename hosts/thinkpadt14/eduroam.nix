{ config, ... }:

{
    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."thinkpad-wifi-keypass.env".path ];
    networking.networkmanager.ensureProfiles.profiles = {
        eduroam = {
            connection = {
                id = "eduroam";
                type = "wifi";
                interface-name = "wlp0s20f3";
            };
            wifi = {
                mode = "infrastructure";
                ssid = "eduroam";
            };
            wifi-security = {
                key-mgmt = "wpa-eap";
                pmf = "1";
            };
            "802-1x" = {
                eap = "tls";
                identity = "rtvillamor@cpp.edu";
                client-cert = "/etc/ssl/certs/eduroam/cert.pem";
                private-key = "/etc/wpa_supplicant/private.key";
                private-key-password = "$private_key_password";
                ca-cert = "/etc/ssl/certs/eduroam/usertrustrsaca.pem";
                #phase1-auth-flags = 32;
            };
            ipv4 = {
                method = "auto";
            };
            ipv6 = {
                method = "auto";
            };
        };
    };
}
