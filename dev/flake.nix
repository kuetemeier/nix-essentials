{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";
  inputs = {
    # flake-parts.url = "github:hercules-ci/flake-parts";
    # # flake-parts use nixos-unstable
    # flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Use nixos-unstable as default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  # This flake is only used for its inputs.
  outputs = {...}: {};
}
