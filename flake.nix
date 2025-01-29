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
    flake-parts.lib.mkFlake {inherit inputs;}
    (
      {
        self,
        lib,
        withSystem,
        moduleWithSystem,
        flake-parts-lib,
        ...
      }: let
        # selfLib = import ./nix/lib {inherit inputs lib;};
        inherit (flake-parts-lib) importApply;
        flakeModules = {
          dev = importApply ./flakeModules/dev {inherit withSystem moduleWithSystem importApply;};
        };
        flakeModules.default = flakeModules.helixPackages;
      in {
        imports =
          [
            inputs.flake-parts.flakeModules.partitions
          ]
          ++ (with flakeModules; [
            dev
          ]);

        inherit flakeModules;

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        flake = {
          templates = {
            base = {
              path = ./templates/base;
              description = "Basic template for new nix projects with flake parts";
            };
          };

          templates.default = self.templates.base;
        };
      }
    );
}
