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
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.nix-unit.modules.flake.default
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
    };
}
