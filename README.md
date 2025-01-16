# nix-essentials

The base of my... and perhaps your Nix code and configurations.

## Documentation

## Used Modules

- [Flake Parts](https://flake.parts/index.html) ([Github](https://github.com/hercules-ci/flake-parts)) 
  provides us the options to represent standard flake attributes as importable
  modules into your flake. It also brings the fantastic `perSystem` function,
  that helps us to write system independent code and libraries.
- [Nix Units](https://nix-community.github.io/nix-unit/) ([Github](https://github.com/nix-community/nix-unit))
  brings "Unit testing for Nix code" to the table.

## Working on this project

- We use [Semantic Versioning](/docs/semantic-versioning.md) for this project.
- Commits should follow the [Conventional Commits](/docs/conventional-commits.md)
  style.
- Please use small and focused commits (see [CI with small commits](/docs/ci-with-small-commits.md))

