{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../modules/vm.nix
      ./../../modules/power.nix
      ./../../modules/impermanence.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "macbook-nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  networking.networkmanager.ensureProfiles.profiles = {
    eduroam = {
      connection = {
	id = "eduroam";
	type = "wifi";
	interface-name = "wlp3s0";
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
	private-key-password = "/iZveR9UY87fX0gf16vK9YJxHlLjio";
	ca-cert = "/etc/ssl/certs/eduroam/usertrustrsaca [jdk].pem";
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    kernelModules = [ "wl" ]; #b43 or wl
    initrd.kernelModules = [ "kvm-intel" "wl" ];
  };

  security.lockKernelModules = true;

  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-63-7.2.6"
  ];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  #i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
        rime-data
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        librime
      ];
    };
  };

  hardware.graphics.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = false;


  # Enable the GNOME Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "";

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rommelvj = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  services.flatpak.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    noto-fonts-cjk-sans
    git
    kdePackages.kdepim-addons
    tlp
    nix-search
    kdePackages.kdeconnect-kde
    hplip
    pciutils
    usbutils
    alsa-utils
    home-manager
    qemu
    fastfetch
    kdePackages.krohnkite
    kdePackages.krdc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.download-buffer-size = 524280000;
  nix.settings.access-tokens = ["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" ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "virbr0" ];
    allowedTCPPorts = [ 22 80 443 ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } #KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } #KDE Connect
    ];
    checkReversePath = false;
  };

  services.tailscale.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

