# flake.nix - Main flake file
#
# SPDX-FileCopyrightText: 2020-2025 Jörg Kütemeier <https://kuetemeier.de/>
# SPDX-License-Identifier: MPL-2.0
#
{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    # flake-parts use nixos-unstable
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Use nixos-unstable as default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.partitions
        inputs.treefmt-nix.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem = {
        config,
        pkgs,
        ...
      }: let
        flat-check = pkgs.runCommandLocal "flat-check" {} ''
          echo "Hello World"
          mkdir $out
          exit 0
        '';
      in {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;

        devShells.default = let
          pythonEnv = pkgs.python3.withPackages (_ps: []);
        in
          pkgs.mkShell {
            packages = [
              pythonEnv
              pkgs.difftastic
              config.treefmt.build.wrapper
              # inputs'.nix-unit.packages.default
              pkgs.just
            ];
            shellHook = ''
              alias j=just
              echo $'\e[1;32mWelcom to development Shell~\e[0m'
              echo -n "Hint: 'just' is aliased to 'j'. "
              echo "Just run 'j' for a list of possible commands"
            '';
          };
        checks = {inherit flat-check;};
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

        # Configuration for flat-flake
        # Allow some exceptions for the "flat" check of this flake
        # GitHub: https://github.com/linyinfeng/flat-flake
        flatFlake = {
          allowed = [
            ["nix-unit" "nix-github-actions"]
          ];
        };

        templates = {
          base = {
            path = ./templates/base;
            description = "Basic template for new nix projects with flake parts";
          };
        };

        templates.default = self.templates.base;

        # System-agnostic tests can be defined here,
        # and will be picked up by `nix flake check`
        tests.testBar = {
          expr = "bar";
          expected = "bar";
        };
      };

      # Extra things to load only when accessing development-specific
      # attributes such as `checks`
      partitionedAttrs.checks = "dev";
      partitionedAttrs.devShells = "dev";
      partitionedAttrs.tests = "dev"; # lib/modules/flake/dogfood.nix
      partitions.dev.module = {
        imports = [
          inputs.treefmt-nix.flakeModule
        ];
        perSystem = {...}: {
          # Use `treefmt` for formatting
          # GitHub: https://github.com/numtide/treefmt-nix
          # Import treefmt config
          treefmt.imports = [./treefmt.nix];
        };
      };
    };
}
