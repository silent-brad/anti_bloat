{
  description = "Anti_Bloat - My NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-darwin = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    thorium = {
      url = "github:Rishabh5321/custom-packages-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-darwin,
      nix-darwin,
      home-manager,
      home-manager-darwin,
      ...
    }@inputs:
    let
      # secrets.nix is gitignored, so we must read it via absolute path (requires --impure).
      # Try common locations across machines/platforms.
      secretsCandidates = [
        /home/redironninja/anti_bloat/secrets/secrets.nix
        /Users/bradwhite/anti_bloat/secrets/secrets.nix
      ];
      foundSecrets = builtins.filter builtins.pathExists secretsCandidates;
      secrets =
        if foundSecrets == [ ] then { } else import (builtins.head foundSecrets);
      theme = import ./themes;
    in
    {
      nixosConfigurations = {
        thinkpad-x220 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs secrets; };
          modules = [
            ./hosts/thinkpad-x220

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.${secrets.username or "redironninja"} = import ./home;
              home-manager.extraSpecialArgs = {
                inherit inputs secrets theme;
                isLinux = true;
                isDarwin = false;
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        macbook-m1 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs secrets; };
          modules = [
            ./hosts/macbook-m1

            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.${secrets.username or "redironninja"} = import ./home;
              home-manager.extraSpecialArgs = {
                inherit inputs secrets theme;
                isLinux = false;
                isDarwin = true;
              };
            }
          ];
        };
      };
    };
}
