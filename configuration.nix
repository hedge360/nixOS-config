{ inputs, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./flatpak.nix
      ./vm.nix
      ./networking.nix
      ./power.nix
      ./librewolf.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      rommelvj = import ./home.nix;
    };
  };

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

  boot.plymouth.enable = false;

  boot.kernelParams = [ "resume_offset=88035328" ];
  boot.resumeDevice = "/dev/disk/by-uuid/14e25d29-90b4-4601-a017-e976bca6af47";

  powerManagement.enable = true;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32*1024; #32 GB Swap
  }];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
        kdePackages.fcitx5-qt
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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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
    ];
  };

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

  #App services
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.kdepim-addons
    kdePackages.korganizer
    #tesseract
    noto-fonts-cjk-sans
    #swtpm
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #neovim
    wget
    discord
    tlp
    kdePackages.kdeconnect-kde
    flatpak
    obs-studio
    lm_sensors
    kdePackages.kdenlive
    #(kdePackages.kdenlive.override {
    #  ffmpeg-full = pkgs.ffmpeg_7-full;
    #})
    hplip
    #gimp3
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
    home-manager
    #distcc
    jdk25_headless
    mpv
    ffmpeg-full
    #krita
    libreoffice
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
    rpi-imager
    kdePackages.kteatime
    pinentry-qt
    foot
    kitty
    waybar
    hyprpaper
    kdePackages.qrca
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable services
  security.apparmor.enable = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

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
    hostName = "builder";
    system = "aarch64-linux";
    protocol = "ssh-ng";
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  #Virtualisation
  virtualisation.waydroid.enable = true;

  nix.settings.download-buffer-size = 524288000;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

