{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./flatpak.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
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

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  #Enable OpenGL
  hardware.graphics.enable = true;
  #hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      hplip
      hplipWithPlugin
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rommelvj = {
    isNormalUser = true;
    description = "Rommel Villamor Jr.";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
      kdePackages.korganizer
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/disk/by-id/ata-WD_Blue_SA510_M.2_2280_500GB_241334801358";
      }
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #TLP Configuration
  services.power-profiles-daemon.enable = false;

  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance-performance"; #power for max battery but little performance, balance-performance for casual/home use, performance is self explanatory
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      #PLATFORM_PROFILE_ON_BAT = "low-power";
      #PLATFORM_PROFILE_ON_AC = "balanced";

      CPU_BOOST_ON_BAT = 0;
      CPU_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;

      USB_AUTOSUSPEND = 0;

      START_CHARGE_THRESH_BAT0 = 60; #I dont think this works
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };

  #App services
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.kdepim-addons
    noto-fonts-cjk-sans
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #neovim
    wget
    discord
    tlp
    kdePackages.kdeconnect-kde
    flatpak
    #osu-lazer
    obs-studio
    lm_sensors
    #ytdownloader
    kdePackages.kdenlive
    hplip
    gimp3
    spotify
    bibata-cursors
    kdePackages.partitionmanager
    usbimager
    ollama
    #protonvpn-gui
    pciutils
    usbutils
    dmidecode
    libgcc
    alsa-utils
    #blocky
    home-manager
    distcc
    lunar-client
    #jdk21_headless
    jdk25_headless
    mpv
    ffmpeg
    krita
    libreoffice
    ferium
    prismlauncher
    (prismlauncher.override {
      jdks = [
        #jdk21_headless
        jdk25_headless
      ];
    })
    yt-dlp
    audacity
    waydroid-nftables
    qemu
    smartmontools
    wlr-randr
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable services
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  boot.blacklistedKernelModules = [ "wacom" ];
  #Auto updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  #Auto garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "delete-older-than 7d";
  nix.settings.auto-optimise-store = true;
  #Flakes enabled
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #Virtualisation
  virtualisation.waydroid.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "rommelvj" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  nix.settings.download-buffer-size = 524288000;

  #services.distccd.enable = true;
  #services.distccd.allowedClients = [ "192.168.1.115/24" "192.168.1.133/24" ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  networking.nftables.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } #KDE Connect
      { from = 45000; to = 60000; } #discord vc ports
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } #KDE Connect
      { from = 45000; to = 60000; } #discord vc ports
    ];
    checkReversePath = false;
  };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

