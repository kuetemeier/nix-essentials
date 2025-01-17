# justfile - Main just configuration file
#
# SPDX-FileCopyrightText: 2020-2025 Jörg Kütemeier <https://kuetemeier.de/>
# SPDX-License-Identifier: MPL-2.0
#

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

alias t := tests
alias test := tests

# Run Unit-Tests
tests:
    @nix-unit \
      --flake .#tests.systems.x86_64-linux
#      --eval-store "{{justfile_directory()}}" \
