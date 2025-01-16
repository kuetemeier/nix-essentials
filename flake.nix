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

    nix-unit.url = "github:nix-community/nix-unit";
    nix-unit.inputs.nixpkgs.follows = "nixpkgs";
    nix-unit.inputs.flake-parts.follows = "flake-parts";
    nix-unit.inputs.treefmt-nix.follows = "treefmt-nix";

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
        inputs.nix-unit.modules.flake.default
        inputs.flake-parts.flakeModules.partitions
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;

        packages.nix-unit = inputs'.nix-unit.packages.default;

        devShells.default = let
          pythonEnv = pkgs.python3.withPackages (_ps: []);
        in
          pkgs.mkShell {
            nativeBuildInputs = [
              pythonEnv
              pkgs.difftastic
              # pkgs.nixdoc
              # pkgs.mdbook
              # pkgs.mdbook-open-on-gh
              # pkgs.mdbook-cmdrun
              config.treefmt.build.wrapper
              inputs'.nix-unit.packages.default
              pkgs.just
            ];
            # inherit (self'.packages.nix-unit) buildInputs;
            # shellHook = lib.optionalString stdenv.isLinux ''
            #   export NIX_DEBUG_INFO_DIRS="${pkgs.curl.debug}/lib/debug:${drvArgs.nix.debug}/lib/debug''${NIX_DEBUG_INFO_DIRS:+:$NIX_DEBUG_INFO_DIRS}"
            #   export NIX_UNIT_OUTPATH=${self}
            # '';
          };

        nix-unit.inputs = {
          # NOTE: a `nixpkgs-lib` follows rule is currently required
          inherit (inputs) nixpkgs flake-parts nix-unit;
        };
        # Tests specified here may refer to system-specific attributes that are
        # available in the `perSystem` context
        nix-unit.tests = {
          "test integer equality is reflexive" = {
            expr = "123";
            expected = "123";
          };
          "frobnicator" = {
            "testFoo" = {
              expr = "foo";
              expected = "foo";
            };
          };
        };
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

        # System-agnostic tests can be defined here, and will be picked up by
        # `nix flake check`
        tests.testBar = {
          expr = "bar";
          expected = "bar";
        };
      };

      # Extra things to load only when accessing development-specific attributes
      # such as `checks`
      partitionedAttrs.checks = "dev";
      partitionedAttrs.devShells = "dev";
      partitionedAttrs.tests = "dev"; # lib/modules/flake/dogfood.nix
      partitions.dev.module = {
        imports = [
          inputs.treefmt-nix.flakeModule
          # self.modules.flake.default
          # ./lib/modules/flake/dogfood.nix
        ];
        perSystem = {config, ...}: {
          # Use `treefmt` for formatting - see https://github.com/numtide/treefmt-nix
          # Config:
          treefmt.imports = [./dev/treefmt.nix];
        };
      };
    };
}
