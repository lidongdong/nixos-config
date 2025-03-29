{
  pkgs,
  lib,
  username,
  ...
}: {
  # ============================= User related =============================

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
  # given the users in this list the right to specify additional substituters via:
  #    1. `nixConfig.substituers` in `flake.nix`
  #    2. command line args `--options substituers http://xxx`
  nix.settings.trusted-users = [username];

  # customise /etc/nix/nix.conf declaratively via `nix.settings`
  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    builders-use-substitutes = true;
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      # chinese pinyin support
      #fcitx5-gtk
      #kdePackages.fcitx5-qt
      #kdePackages.fcitx5-chinese-addons
      #kdePackages.fcitx5-configtool
      #kdePackages.fcitx5-with-addons
      fcitx5-nord
      
      # rime support
      fcitx5-rime
      rime-data
    ]; 
  };

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # nerdfonts
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    enableLsColors = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    autosuggestions.strategy = [ "completion" "history" ];
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l --sort=modified";
      rem = "kitty +kitten ssh l@10.20.27.200";
    };
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "fzf"
        "colored-man-pages"
      ];
    };
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.extraHosts = ''
    10.20.27.200       lidong-tester
    10.20.26.110       ci.innogrit.com    gitlab.innogrit.com
    10.20.30.41      inno_essd_011
    10.20.30.37      inno_essd_012
    10.20.30.38      inno_essd_013
    10.20.30.39      inno_essd_014
    10.20.30.42      inno_essd_015
    10.20.30.40      assistant001
    10.20.30.50      inno_essd_021
    10.20.30.43      inno_essd_023
    10.20.30.44      inno_essd_025
    10.20.30.48      inno_essd_026
    10.20.30.46      assistant002
    10.20.30.28      inno_essd_031
    10.20.30.29      inno_essd_032
    10.20.30.30      inno_essd_033
    10.20.30.31      inno_essd_034
    10.20.30.32      inno_essd_035
    10.20.30.33      inno_essd_037
    10.20.30.34      inno_essd_038
    10.20.30.35      inno_essd_039
    10.20.30.36      assistant003
    10.20.30.21      inno_essd_041
    10.20.30.25      inno_essd_042
    10.20.30.24      inno_essd_043
    10.20.30.26      inno_essd_044
    10.20.30.23      inno_essd_045
    10.20.30.27      assistant004
    10.20.30.49      inno-essd-pi-008
  '';

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
      # HostKeyAlgorithms = "+ssh-rsa";  # 允许服务端使用 ssh-rsa
      # PubkeyAcceptedAlgorithms = "+ssh-rsa";  # 允许客户端用 ssh-rsa 认证
    };
    openFirewall = true;
  };

  programs.ssh = {
    extraConfig = ''
      Host *
        HostKeyAlgorithms +ssh-rsa
        PubkeyAcceptedAlgorithms +ssh-rsa
    '';
  };

  # davfs2 to mount nutstore (Webdav)
  services.davfs2 = {
    enable = true;
    settings = {
      sections = {
        "/home/dd/nutstore" = {
          ignore_dav_header = 1;
        };
      };
    };
  };

  environment.variables = {
    TERMINAL = "kitty";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    scrot
    fastfetch
    snipaste
    wechat-uos

    # SHELL
    zsh
    oh-my-zsh
    fzf

    # TERM
    kitty

    obsidian
  ];

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # services.power-profiles-daemon = {
  #   enable = true;
  # };
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

}
