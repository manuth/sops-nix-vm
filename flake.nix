{
  description = "NixOS Machine Configurations by manuth";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    sops-nix.url = "github:Mic92/sops-nix?ref=f1b0adc27265274e3b0c9b872a8f476a098679bd";
  };

  outputs = { self, nixpkgs, sops-nix }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        sops-nix.nixosModules.sops
        (
          { config, ... }: {
            services.openssh.enable = true;

            sops = {
              defaultSopsFile = ./secrets/global.yaml;

              age = {
                generateKey = true;
              };

              secrets = {
                default_password = {};
              };
            };
          })
      ];
    };

    devShells.x86_64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
        pkgs.mkShellNoCC {
          packages = [
            pkgs.nixos-rebuild
          ];
        };
  };
}
