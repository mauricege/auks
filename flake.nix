{
  description = "auks";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      inherit (nixpkgs) lib;
      name = "auks";
      overlay = final: prev: {
        inherit (overlayPackages prev prev) auks;
      };
      overlayPackages = import ./pkgs;
      shell = ./shell.nix;
    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          p = inputs.nixpkgs.legacyPackages.${system};

          packages = (overlayPackages p p).auks;
        in
        {
          # Use the legacy packages since it's more forgiving.
          # inherit overlay;
          legacyPackages = packages;
          inherit packages;
        }
        //
        (
          if packages ? checks then {
            checks = packages.checks;
          } else { }
        )
      ) //
    {
      inherit overlay;
      nixosModules = {
        # slurmreport = import ./modules/services/slurmreport.nix;
        # slurmusersettings = import ./modules/services/slurmusersettings.nix;
      };
    };
}
