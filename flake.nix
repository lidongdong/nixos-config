{
  description = "lidong's nixos flake configuration";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      um990 = let
        username = "dd";
        specialArgs = {inherit username;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/um990
            ./users/${username}/nixos.nix

            # 将 home-manager 配置为 nixos 的一个 module
            # 这样在 nixos-rebuild switch 时，home-manager 配置也会被自动部署
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # 这里的 ryan 也得替换成你的用户名
              # 这里的 import 函数在前面 Nix 语法中介绍过了，不再赘述
              home-manager.users.${username} = import ./users/${username}/home.nix;

              # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
              # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
              home-manager.extraSpecialArgs = inputs // specialArgs;
            }
          ];
        };
    };
  };
}
