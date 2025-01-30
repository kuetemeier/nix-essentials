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
  partitionedAttrs.checks = "essentialsCheckFormats";
  partitions.essentialsCheckFormats.extraInputsFlake = ./.;
  partitions.essentialsCheckFormats.module = {inputs, ...}: {
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
      treefmt.imports = [./../formats/treefmt.nix];
      checks = {
        testEssentialFormats =
          # Run treefmt in CI mode ( --no-cache --fail-onchange )
          pkgs.runCommandLocal "checkEssentialsFormats" {
          } ''
            echo "Running nix-essentials format Checks..."
            # echo "Running treefmt..."
            # ${treefmtPkg}/bin/treefmt --ci
            echo "Running editorconfig-check"
            ${pkgs.editorconfig-checker}/bin/editorconfig-checker
            touch "$out"
          '';
      };
    };
  };
}
