{
	description = "lidong's nixos flake configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
	};

	outputs = { self, nixpkgs, ...}@inpus: {
		nixosConfigurations.intelligence00 = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
			];
		};
	};
}
