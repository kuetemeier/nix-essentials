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
    # TODO: Needs more testing - is treefmt a requirement for dev shell?
    # Use `treefmt` for formatting
    # GitHub: https://github.com/numtide/treefmt-nix
    # Import treefmt config
    # treefmt.imports = [./../formats/treefmt.nix];

    # formatter = config.treefmt.build.wrapper;

    devShells.default = pkgs.mkShell {
      packages = [
        # pythonEnv
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

    devShells.python = let
      pythonEnv = pkgs.python3.withPackages (_ps: []);
    in
      pkgs.mkShell {
        packages = [
          pythonEnv
        ];
      };
  };
}
