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

    nix-unit.url = "github:nix-community/nix-unit";
    nix-unit.inputs.nixpkgs.follows = "nixpkgs";
    nix-unit.inputs.flake-parts.follows = "flake-parts";
    nix-unit.inputs.nix-github-actions.follows = "nix-github-actions";
    nix-unit.inputs.treefmt-nix.follows = "treefmt-nix";

    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";

    # This relates to the hardcoded version of flflake-compat in partitions
    # from flflake-parts. You can find this in the file
    # https://github.com/hercules-ci/flake-parts/blob/main/extras/partitions.nix
    flake-compat.url = "github:edolstra/flake-compat?ref=9ed2ac151eada2306ca8c418ebd97807bb08f6ac";
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
          dev = importApply ./flakeModules/dev {
            inherit withSystem moduleWithSystem importApply;
          };
          formats = importApply ./flakeModules/formats {
            inherit withSystem moduleWithSystem importApply;
          };
          # TODO: Need more testing
          # checkFormats = importApply ./flakeModules/checkFormats {
          #   inherit withSystem moduleWithSystem importApply;
          # };
        };
        flakeModules.default = flakeModules.dev;
      in {
        imports =
          [
            inputs.flake-parts.flakeModules.partitions
          ]
          ++ (with flakeModules; [
            dev
            formats
            # checkFormats
          ]);

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        flake = {
          inherit flakeModules;

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
