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
  partitionedAttrs.formatter = "essentialsFormats";
  partitions.essentialsFormats.extraInputsFlake = ./.;
  partitions.essentialsFormats.module = {inputs, ...}: {
    imports = [
      inputs.treefmt-nix.flakeModule
    ];
    perSystem = {
      config,
      pkgs,
      inputs',
      system,
      lib,
      ...
    }: let
      treefmtPkg = config.treefmt.build.wrapper;
    in {
      # Use `treefmt` for formatting
      # GitHub: https://github.com/numtide/treefmt-nix
      # Import treefmt config
      treefmt.imports = [./treefmt.nix];

      formatter = treefmtPkg;
    };
  };
}
