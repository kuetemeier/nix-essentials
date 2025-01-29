#
# SPDX-FileCopyrightText: 2020-2025 Jörg Kütemeier <https://kuetemeier.de/>
# SPDX-License-Identifier: MPL-2.0
#
localFlake: {
  lib,
  config,
  self,
  inputs,
  ...
}: {
  # Extra things to load only when accessing development-specific
  # attributes such as `checks`
  partitionedAttrs.checks = "nedev";
  partitionedAttrs.devShells = "nedev";
  partitionedAttrs.tests = "nedev";
  partitionedAttrs.formatter = "nedev";
  partitions.nedev.extraInputsFlake = ./.;
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
      treefmt.imports = [./treefmt.nix];

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

  flake = {
    # Configuration for flat-flake
    # Allow some exceptions for the "flat" check of this flake
    # GitHub: https://github.com/linyinfeng/flat-flake
    flatFlake = {
      # Intentionally empty, but must be present
    };
  };
}
