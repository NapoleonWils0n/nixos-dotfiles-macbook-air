{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "djwilcox";
  home.homeDirectory = "/home/djwilcox";
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.


    imports = [
      ./programs/firefox/firefox.nix
      ./programs/dconf/dconf.nix
    ];


    programs = {
      emacs = {
        enable = true;
        package = pkgs.emacs29-pgtk;
        extraPackages = epkgs: with epkgs; [
          async
          consult
          doom-themes
          doom-modeline
          ednc
          elfeed
          elfeed-org
          elfeed-tube
          elfeed-tube-mpv
          tree-sitter-langs
          embark
          embark-consult
          emmet-mode
          evil
          evil-collection
          evil-leader
          fd-dired
          git-auto-commit-mode
          google-translate
          hydra
          iedit
          marginalia
          mpv
          nerd-icons
          nix-mode
          ob-async
          orderless
          rg
          s
          shrink-path
          tsc
          undo-tree
          vertico
          wgrep
          which-key
          yaml-mode
        ];
      };
      gpg = {
        enable = true;
      };
    };

    services = {
      emacs = {
        enable = true;
        client.enable = true;
      };
      gnome-keyring = {
        enable = true;
      };
      gpg-agent = {
        enable = true;
        extraConfig = ''
          allow-emacs-pinentry
          allow-loopback-pinentry
        '';
        pinentryFlavor = "curses";
      };
      mpd = {
        enable = true;
        musicDirectory = "~/Music";
        network = {
          startWhenNeeded = true;
        };
        extraConfig = ''
          audio_output {
            type "pipewire"
            name "My PipeWire Output"
          }
        '';
      };
    };

    # systemd
    systemd.user.sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      DISPLAY = ":0";
      WAYLAND_DISPLAY = "wayland-0";
    };

    # home sessions variables
    home.sessionVariables = {
      XCURSOR_THEME = "Adwaita";
    };

    # gtk
    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };


    # xdg directories
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        publicShare = null;
        templates = null;
      };
    };

  # mpv mpris 
  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [ self.mpvScripts.mpris ];
      };
    })
  ];


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    abook
    alacritty
    apg
    aria
    aspell
    aspellDicts.en
    bc
    cantarell-fonts
    chromium
    curl
    dict
    exiftool
    file
    fira-code
    ffmpeg
    fzf
    git
    gnumake
    imagemagick
    jq
    libwebp
    mpc_cli
    mpd
    mpv
    mutt
    ncmpc
    oathToolkit
    obs-studio
    openvpn
    pandoc
    pinentry-curses
    playerctl
    ripgrep
    socat
    sox
    shellcheck
    tmux
    translate-shell
    tree-sitter
    ts
    unzip
    urlscan
    urlview
    yt-dlp
    weechat
    wget
    wl-clipboard
    widevine-cdm
    vim
    zip
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/djwilcox/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
