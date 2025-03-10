{ pkgs, ... }:

{
  imports = [
    ../../home/core.nix
    ../../home/programs
  #  ../../home/shell
  ];

  # git 相关配置
  programs.git = {
    userName = "lidongdong";
    userEmail = "accelerateli@outlook.com";
  };

}
