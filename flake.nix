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
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
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
        pkgs,
        ...
      }: {
        # }: let
        #   checkFlatFlake =
        #     pkgs.runCommand "checkFlatFlake" {
        #       nativeBuildInputs = [
        #         pkgs.nix
        #       ];
        #     } ''
        #       mkdir $out
        #       nix --sandbox false --extra-experimental-features nix-command \
        #         run github:linyinfeng/flat-flake -- check ${self}
        #     '';
        # in {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;
        # packages.checkFlatFlake = checkFlatFlake;

        # checks = {
        #   inherit flat-check;
        # };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

        # Configuration for flat-flake
        # Allow some exceptions for the "flat" check of this flake
        # GitHub: https://github.com/linyinfeng/flat-flake
        flatFlake = {
          # allowed = [
          #   ["nix-unit" "nix-github-actions"]
          # ];
        };

        templates = {
          base = {
            path = ./templates/base;
            description = "Basic template for new nix projects with flake parts";
          };
        };

        templates.default = self.templates.base;
      };

      # Extra things to load only when accessing development-specific
      # attributes such as `checks`
      partitionedAttrs.checks = "nedev";
      partitionedAttrs.devShells = "nedev";
      partitionedAttrs.tests = "nedev";
      partitionedAttrs.formatter = "nedev";
      partitions.nedev.extraInputsFlake = ./dev;
      partitions.nedev.module = {inputs, ...}: {
        imports = [
          inputs.treefmt-nix.flakeModule
          inputs.nix-unit.modules.flake.default
        ];
        perSystem = {
          config,
          pkgs,
          inputs',
          system,
          lib,
          ...
        }: {
          # Use `treefmt` for formatting
          # GitHub: https://github.com/numtide/treefmt-nix
          # Import treefmt config
          treefmt.imports = [./dev/treefmt.nix];

          formatter = config.treefmt.build.wrapper;

          devShells.default = let
            pythonEnv = pkgs.python3.withPackages (_ps: []);
          in
            pkgs.mkShell {
              packages = [
                pythonEnv
                pkgs.difftastic
                config.treefmt.build.wrapper
                inputs'.nix-unit.packages.default
                pkgs.just
              ];
              shellHook = ''
                alias j=just
                echo $'\e[1;32mWelcom to development Shell~\e[0m'
                echo -n "Hint: 'just' is aliased to 'j'. "
                echo "Just run 'j' for a list of possible commands"
              '';
            };

          nix-unit.package = inputs'.nix-unit.packages.nix-unit;
          nix-unit.inputs = {
            # NOTE: a `nixpkgs-lib` follows rule is currently required
            inherit (inputs) nixpkgs flake-parts treefmt-nix flake-compat;
          };
          nix-unit.allowNetwork = true;

          checks = {
            test =
              pkgs.runCommandLocal "ensure-dependencies" {
              } ''
                echo "${inputs.flake-compat.rev}"
                touch "$out"
              '';
          };

          # checks = {
          #   tests =
          #     pkgs.runCommand "tests"
          #     {
          #       nativeBuildInputs = [
          #         # inputs.nix-unit.packages.${system}.default
          #         inputs'.nix-unit.packages.default
          #       ];
          #     } ''
          #       export HOME="$(realpath .)"
          #       # The nix derivation must be able to find all used inputs in the nix-store
          #       # because it cannot download it during buildTime.
          #       nix-unit --eval-store "$HOME" \
          #       --extra-experimental-features flakes \
          #       ${lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "--override-input ${name} ${value}") (lib.filterAttrs (name: _: name != "self" && name != "nix-unit") inputs))} \
          #       --flake ${self}#tests
          #       touch $out
          #     '';
          # };

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
      };
      # flake = {
      #   tests.testPass = {
      #     expr = 3;
      #     expected = 3;
      #   };
      # };
    };
}
