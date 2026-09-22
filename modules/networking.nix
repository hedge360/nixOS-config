{ config, pkgs, ... }:

{
    networking.networkmanager.enable = true;
    networking.nftables.enable = true;
    
    boot.kernelParams = [
    	"btintel.enable_hci_reset=0"
	"btintel.disable_autosuspend=1"
    ];


    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wifi-keypass.env".path ];
    networking.networkmanager.ensureProfiles.profiles = {
	eduroam = {
	    connection = {
		id = "eduroam";
		type = "wifi";
		interface-name = "wlp1s0";
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
		#private-key-password = "K2lJadr6YzgKeEwjdKqrGsH4SHCHQf";
		private-key-password = "$private_key_password";
		ca-cert = "/etc/ssl/certs/eduroam/usertrustrsaca.pem";
		phase1-auth-flags = 32;
	    };
	    ipv4 = {
		method = "auto";
	    };
	    ipv6 = {
		method = "auto";
	    };
	};
    };
    
    services.dnsproxy = {
        enable = true;
        settings = {
        listen-addrs = [ "127.0.0.1" ];
        listen-ports = [ 53 ];
        tls-port = [ 853 ];
        https-port = [ 443 ];
        upstream = [
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"
            "https://1.1.1.1/dns-query"
            "1.1.1.1"
            "1.0.0.1"
            "127.0.0.1:5353"
        ];
        };
        flags = [ "--verbose" ];
    };

    services.cloudflare-warp.enable = true;

    services.tailscale = {
        enable = true;
    };

    systemd.services.tailscaled.serviceConfig.Environment = [
	"TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

    systemd.services.dnsproxy.serviceConfig = {
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    };

    environment.etc."systemd/resolved.conf.d/dnsproxy.conf".text = ''
        [Resolve]
        DNS=127.1.0.0.1
        FallbackDNS=
        DNSStubListener=no
    '';

    services.resolved.enable = true;
    networking.nameservers = [ "127.0.0.1" ];
    networking.networkmanager.dns = "systemd-resolved";

    services.dnsmasq = {
        enable = true;
        settings = {
        port = 5353;
        no-resolv = true;
        bogus-priv = true;
        strict-order = true;
        server = [
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"
            "1.1.1.1"
            "1.0.0.1"
        ];
        };
    };

    # Open ports in the firewall.
    networking.firewall = {
        enable = true;
	trustedInterfaces = [
	    config.services.tailscale.interfaceName
	    "virbr0"
	    "CloudflareWARP"
	];
        allowedTCPPorts = [ 80 443 ];
        allowedTCPPortRanges = [
        { from = 1714; to = 1764; } #KDE Connect
        #{ from = 45000; to = 60000; } #discord vc ports
        ];
        allowedUDPPorts = [ 
	    500
	    1701
	    2408
	    4500
	    4443
	    8443
	    8095 #MASQUE and wireguard fallbacks (Cloudflare WARP)
	    config.services.tailscale.port
	];
        allowedUDPPortRanges = [
        { from = 1714; to = 1764; } #KDE Connect
        #{ from = 45000; to = 60000; } #discord vc ports
        ];
        checkReversePath = false;
    };

    #Bypass internet censorship in China
    #For more information, visit https://github.com/v2rayA/v2rayA
    #services.v2raya.enable = true;

    programs.wireshark.enable = true;

    environment.systemPackages = with pkgs; [
	#v2raya
	#xray
	wireshark
    ];
}
