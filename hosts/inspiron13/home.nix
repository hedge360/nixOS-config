{ config, pkgs, inputs, lib, ... }:

{
  home.username = "rommelvj";
  home.homeDirectory = "/home/rommelvj";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.bash.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    plasma-panel-colorizer
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
    QS_ICON_THEME = "Papirus";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    systemd.enable = false;
    settings = {
	#settings to enable
	wallpaper = "~/Downloads/Wallpapers/20260207_102921.jpg";
	osd = {
	    enabled = true;
	    enableBrightness = false;
	};
	volume = {
	    max = 150;
	    default = 100;
	};
	services = {
	    maxVolume = 1.5;
	};
    };
    extraConfig = '''';
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      background_opacity = "0.7";
      background_blur = 5;
    };
    themeFile = "Catppuccin-Mocha";
  };

  #waydroid user session and resource management
  systemd.user.services.waydroid-session = {
    Unit = {
      Description = "Waydroid User Session";
      After = [ "waydroid-container.service" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.waydroid-nftables}/bin/waydroid session start";
      ExecEnd = "${pkgs.waydroid-nftables}/bin/waydroid session stop";

      #Clean processes on exit
      KillMode = "mixed";

      #Resource Limits
      MemoryMax = "12G";
      MemoryHigh = "8G";

      TimeoutStopSpec = "15s";
      Restart = "on-failure";
    };
  };

  #git
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "hedge360";
        email = "scion5u@gmail.com";
      };
      init.defaultBranch = "main";
      gpg.format = "ssh";
      push = { autoSetupRemote = true; };
      credential.helper = "libsecret";
      alias = {
        c = "commit";
        s = "status";
        a = "add";
        p = "push";
        cl = "clone";
        pl = "pull";
      };
    };
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMK/FzqpeeCt72mQxRcTlP5HLJshjybbQ0UIZKx8jM/ scion5u@gmail.com";
      signByDefault = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      ForwardAgent = false;
      addKeysToAgent = "yes";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };
}
