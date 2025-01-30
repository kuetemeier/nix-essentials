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
  partitionedAttrs.devShells = "essentialsDev";
  partitions.essentialsDev.extraInputsFlake = ./.;
  partitions.essentialsDev.module = {inputs, ...}: {
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
      # treefmt.imports = [./../formats/treefmt.nix];

      # formatter = config.treefmt.build.wrapper;

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
            pkgs.editorconfig-checker
          ];
          shellHook = ''
            alias j=just
            echo $'\e[1;32mWelcome to development Shell~\e[0m'
            echo -n "Hint: 'just' is aliased to 'j'. "
            echo "Just run 'j' for a list of possible commands"
          '';
        };
    };
  };
}
