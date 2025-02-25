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
}
