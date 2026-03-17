{
  description = "Anti_Bloat - My NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pinnacle = {
      url = "github:pinnacle-comp/pinnacle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      secretsPath = ./secrets/secrets.nix;
      secrets =
        if builtins.pathExists secretsPath
        then import secretsPath
        else {};
    in {
      nixosConfigurations = {
        thinkpad-x220 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs secrets; };
          modules = [
            ./hosts/thinkpad-x220

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.redironninja = import ./home;
              home-manager.extraSpecialArgs = { inherit inputs secrets; };
            }
          ];
        };
      };
    };
}
