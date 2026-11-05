{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./sops.nix
      ./eduroam.nix
      ./../../modules/btrfs.nix
      ./../../modules/flatpak.nix
      ./../../modules/vm.nix
      ./../../modules/networking.nix
      ./../../modules/power.nix
      ./../../modules/librewolf.nix
      ./../../modules/waydroid.nix
      ./../../modules/impermanence.nix # NOTE: DO NOT REMOVE THIS MODULE!!!!!
      inputs.home-manager.nixosModules.home-manager
      inputs.flatpaks.nixosModules.default
    ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      rommelvj = import ./home.nix;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;
  boot.loader.limine.enable = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    limine = {
      efiSupport = true;
      secureBoot.enable = true;
      #style.wallpapers = [
	#"/boot/limine/wallpapers/wallpapers-birdSilhouette.jpg"
      #];
      extraConfig = ''
        measured_boot: yes
      '';
    };
  };

  fileSystems = {
    "/".options = [
      "compress=zstd"
    ];
    "/home".options = [
      "compress=zstd"
    ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
  };

  boot.plymouth.enable = false;

  boot.resumeDevice = "/dev/disk/by-uuid/51d585fe-2edb-4842-9907-2902875b9304";

  powerManagement.enable = true;

  hardware.acpilight.enable = true;

  swapDevices = [{
    device = "/dev/disk/by-uuid/51d585fe-2edb-4842-9907-2902875b9304";
  }];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "thinkpadt14-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ "rommelvj" ];
    keepEnv = true;
    persist = true;
  }];

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  services.fprintd.enable = true;

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
        kdePackages.fcitx5-qt
      ];
    };
  };
  
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
  ];

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
  hardware.graphics.extraPackages = with pkgs; [ 
    intel-media-driver
    pocl
  ];
  #hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #portalPackage = pkgs.xdg-desktop-portal-wlr;
  };
  environment.sessionVariables.HYPRLAND_NO_RT = "1";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
    enable = lib.mkForce true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  hardware.alsa = {
    enable = true;
    enablePersistence = true;
    #enableBluetooth = true;
  };
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';

/*
  services.mpd = {
    enable = true;
    user = "rommelvj";
    settings = {
      audio_output = [
	{
	  type = "pipewire";
	  name = "My PipeWire Output";
	}
      ];
    };
  };

  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.rommelvj.1000}";
  };
*/

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rommelvj = {
    isNormalUser = true;
    description = "Rommel Villamor Jr.";
    hashedPasswordFile = config.sops.secrets.hashed-password.path;
    extraGroups = [ "networkmanager" "wheel" "wireshark" "tss" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
    ];
  };

  users.users.root.hashedPasswordFile = config.sops.secrets.hashed-password.path;

  services.smartd = {
    enable = true;
    #devices = [
    #  {
    #    device = "/dev/disk/by-id/ata-WD_Blue_SA510_M.2_2280_500GB_241334801358";
    #  }
    #];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #App services
  services.flatpak.enable = true;
  security.apparmor.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      dwproton-bin
      proton-ge-bin
    ];
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
    #localNetworkGameTransfers.openFirewall = true;
  };

  programs.obs-studio = {
    enable = true;
    #enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [ 
      wlrobs
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    opts.number = true;
    opts.relativenumber = true;
    opts.shiftwidth = 4;
    viAlias = true;
    vimAlias = true;
    colorschemes.catppuccin = {
      enable = true;
      autoLoad = true;
      settings = {
	flavour = "mocha";
	integrations.nvimtree = true;
	integrations.treesitter = true;
	term_colors = true;
      };
    };
    extraConfigLuaPost = ''
      vim.cmd([[
        colorscheme catppuccin-mocha
      ]])
    '';
  };

  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kdepim-addons
    kdePackages.korganizer
    noto-fonts-cjk-sans
    #tesseract
    #swtpm
    hyprshutdown
    git
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    discord-development
    element-desktop
    tlp
    kdePackages.kdeconnect-kde
    flatpak
    lm_sensors
    kdePackages.kdenlive
    hplip
    gimp
    spotify
    bibata-cursors
    kdePackages.partitionmanager
    usbimager
    #ollama
    #proton-vpn
    pciutils
    usbutils
    dmidecode
    libgcc
    alsa-utils
    home-manager
    #distcc
    jdk25_headless
    mpv
    ffmpeg-full
    krita
    libreoffice-qt
    ferium
    prismlauncher
    (prismlauncher.override {
      jdks = [
        jdk25_headless
      ];
    })
    yt-dlp
    waydroid-nftables
    qemu
    smartmontools
    #gnuplot
    #kdePackages.kalgebra
    nix-search-cli
    #rpi-imager
    kdePackages.kteatime
    pinentry-qt
    foot
    kitty
    waybar
    hyprpaper
    kdePackages.qrca
    audacity
    arion
    bluez-experimental
    firmware-updater
    hydra-check
    fastfetch
    #waypaper
    kdePackages.bluedevil
    #vulnix
    #winboat
    wlr-randr
    hyprshot
    chromium
    ddcutil
    brightnessctl
    #kdePackages.plasma-browser-integration
    rnote
    age
    sops
    teams-for-linux
    tree
    sbctl
    ssh-tpm-agent
    tor-browser
    zoom-us
    #xdg-desktop-portal-hyprland
    bitwarden-desktop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable services
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  services.openssh.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  #boot.blacklistedKernelModules = [ "wacom" ];

  #Auto updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  #Auto garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-7d";
    persistent = true;
  };

  nix.optimise = {
    automatic = true;
    dates = [ "daily" ];
    persistent = true;
  };

  #Flakes enabled
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.buildMachines = [{
    #Documentation: https://wiki.nixos.org/wiki/Distributed_build
    hostName = "100.107.245.109";
    system = "aarch64-linux";
    protocol = "ssh-ng";
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "qemu-x86_64" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.settings.download-buffer-size = 524288000;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

