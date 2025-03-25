{ pkgs, ... }:

{
  imports = [
    ../../home/core.nix
    ../../home/programs
  #  ../../home/shell
  ];

  home.packages = with pkgs; [
    digikam
    gimp
    darktable
    keepass
    zellij
    emacs
  ];

  # git 相关配置
  programs.git = {
    userName = "lidongdong";
    userEmail = "accelerateli@outlook.com";
  };

  programs.kitty = {
    enable = true;
    themeFile = "Solarized_Dark";
    shellIntegration.enableZshIntegration = true;
    keybindings = {
    };
  };

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
}
