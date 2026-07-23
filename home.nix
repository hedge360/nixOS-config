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
 /* 
  wayland.windowManager.hyprland = { # Migrate to here eventually
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    systemd.variables = [ "--all" ];
    settings = {
      "menu" = { _var = "krunner"; };
      "mod" = { _var = "SUPER"; };

      monitor = ", 1920x1080@auto, 0x0, 1.2";
      
      on = {
        _args = [
	  "hyprland.start"
	  (lib.generators.mkLuaInline ''
	    function()
	      hl.exec_cmd("fcitx5")
	      hl.exec_cmd("caelestia shell -d")
	    end
	  '')
	];
      };
      general = lib.generators.mkLuaInline ''
        hl.general = {
	  gaps_in = 5;
	  gaps_out = 20;

	  border_size = 2;

	  ["col.active_border"] = "rgba(33ccffee) rgba(00ff99ee) 45deg";
	  ["col.inactive_border"] = "rgba(595959aa)";

	  resize_on_border = false;

	  allow_tearing = false;
	
	  layout = "dwindle";
      	};
      '';

      decoration = lib.generators.mkLuaInline ''
      	hl.decoration = {
	  rounding = 10;
	  rounding_power = 2;

	  active_opacity = 1.0;
	  inactive_opacity = 0.9;

	  shadow = {
	    enabled = true;
	    range = 4;
	    render_power = 3;
	    color = "rgba(1a1a1aee)";
	  };

	  blur = {
	    enabled = true;
	    size = 3;
	    passes = 1;

	    vibrancy = 0.1696;
	  };
        };
      '';

      animations = lib.generators.mkLuaInline ''
        hl.animations = {
	  enabled = true;
        };
      '';

      master = lib.generators.mkLuaInline ''
        hl.master = {
	  new_status = "master";
        };
      '';

      misc = lib.generators.mkLuaInline ''
        hl.misc = {
	  force_default_wallpaper = false;
	  disable_hyprland_logo = true;
        };
      '';
      
      input = lib.generators.mkLuaInline ''
        hl.input = {
	  kb_layout = "us";
	  kb_variant = "";
	  kb_model = "";
	  kb_options = "";
	  kb_rules = "";

	  follow_mouse = true;
	  sensitivity = 0;

	  touchpad = {
	    natural_scroll = false;
	  };
        };
      '';

      gesture = [
	{
	  _args = [ "3, horizontal, workspace" ];
	}
      ];

      device = [
      	{
	  name = "epic-mouse-v1";
	  sensitivity = -0.5;
	}
      ];
      
      bind = [
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + T\"")
	    "exec"
	    "discord"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + F\"")
	    "exec"
	    "librewolf"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + Q\"")
	    "exec"
	    "konsole"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + C\"")
	    "killactive"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + M\"")
	    "exec"
	    "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + E\"")
	    "exec"
	    "dolphin"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + J\"")
	    "exec"
	    "spotify"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + V\"")
	    "togglefloating"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + R\"")
	    "exec"
	    (lib.generators.mkLuaInline "menu")
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + P\"")
	    "pseudo"
	  ];
	}
      	{
	  _args = [
	    "PRINT"
	    "exec"
	    "hyprshot -m region"
	  ];
	}
      	{
	  _args = [
	    "SHIFT + PRINT"
	    "exec"
	    "hyprshot -m output"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + left\"")
	    "movefocus"
	    "l"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + right\"")
	    "movefocus"
	    "r"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + up\"")
	    "movefocus"
	    "u"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + down\"")
	    "movefocus"
	    "d"
	  ];
	}
	#workspace switching 1-10
      ] ++ (builtins.map (n: {
      	_args = [
	  (lib.generators.mkLuaInline "mod .. \" + ${toString n}\"")
	  "workspace"
	  (toString n)
	];
      }) (builtins.genList (n: n+1) 10))
      ++ (builtins.map (n: {
      	_args = [
	  (lib.generators.mkLuaInline "mod .. \" + SHIFT + ${toString n}\"")
	  "movetoworkspace"
	  (toString n)
	];
      }) (builtins.genList (n: n+1) 10))
      ++ [
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + S\"")
	    "togglespecialworkspace"
	    "magic"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + SHIFT + S\"")
	    "movetoworkspace"
	    "special:magic"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + mouse_down\"")
	    "workspace"
	    "e+1"
	  ];
	}
      	{
	  _args = [
	    (lib.generators.mkLuaInline "mod .. \" + mouse_up\"")
	    "workspace"
	    "e-1"
	  ];
	}
      ];
      
      env = [
      	"XDG_CURRENT_DESKTOP,Hyprland"
	"XCURSOR_SIZE,24"
	"HYPRCURSOR_SIZE,24"
	"QT_QPA_PLATFORM,wayland"

	"GTK_IM_MODULE,fcitx"
	"QT_IM_MODULE,fcitx"
      ];

      window_rule = [
	{
	  match = { class = ".*?"; };
	  nomaximizerequest = true;
	}
	{
	  match = { xwayland = true; floating = true; };
	  no_focus = true;
	}
	{
	  match = {class = "hyprland-run"; };
	  float = true;
	  move = "20 300";
	}
      ];
      
      xwayland = lib.generators.mkLuaInline ''
        hl.xwayland = {
	  force_zero_scaling = true;
        };
      '';
    };
  };
*/
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
    };
    aliases = {
      c = "commit";
      s = "status";
      a = "add";
      p = "push";
      cl = "clone";
      pl = "pull";
    };
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMK/FzqpeeCt72mQxRcTlP5HLJshjybbQ0UIZKx8jM/ scion5u@gmail.com";
      signByDefault = true;
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  programs.neovim = {
    enable = true;
    withRuby = true;
    withPython3 = true;
    extraConfig = ''
        set number
	syntax on
    '';
    plugins = with pkgs.vimPlugins; [
	nvim-treesitter
	{
	    plugin = nvim-treesitter;
	    type = "lua";
	    config = ''
		require('nvim-treesitter').setup {
		    highlight = {
		    	enable = true,
		    },
		    indent = {
		        enable = true,
		    },
		}
	    '';
	}
	nvim-java
    ];
  };
}
