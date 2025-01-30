{
  description = ''
    Private inputs for development purposes. These are used by the top level flake in the `dev`
    partition, but do not appear in consumers' lock files.
  '';

  inputs = {
    # flake-parts.url = "github:hercules-ci/flake-parts";
    # # flake-parts use nixos-unstable
    # flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Use nixos-unstable as default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

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

  # This flake is only used for its inputs.
  outputs = {...}: {
    flatFlake = {};
  };
}
