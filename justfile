# Print command list
default:
    @just --list


alias f := format
alias fmt := format

# Format and lint all souce files
format:
    treefmt

# Health Check for nix environment
health:
    nix run "github:juspay/nix-browser#nix-health"

# Ensure Flake inputs are flat
flat:
    nix run github:linyinfeng/flat-flake -- check .
