{ config, pkgs, ... }:

{
  # 注意修改这里的用户名与用户目录
  home.username = "dd";
  home.homeDirectory = "/home/dd";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    # 如下是我常用的一些命令行工具，你可以根据自己的需要进行增删
    fastfetch

    # archives
    zip
    unzip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    aria2 # A lightweight multi-protocol & multi-source command-line download utility

    # productivity
    btop  # replacement of htop/nmon

    # system call monitoring
    lsof # list open files

    # system tools
  ];

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "lidongdong";
    userEmail = "accelerateli@outlook.com";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO 在这里添加你的自定义 bashrc 内容
    bashrcExtra = ''
    '';

    # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
    shellAliases = {
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
