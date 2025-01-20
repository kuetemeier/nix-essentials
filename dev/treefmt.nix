# treefmt - Configuration for treefmt in dev-shell
#
# SPDX-FileCopyrightText: 2020-2025 Jörg Kütemeier <https://kuetemeier.de/>
# SPDX-License-Identifier: MPL-2.0
#
{...}: {
  # Used to find the project root
  projectRootFile = "flake.lock";

  settings.global.excludes = [
    # No formating and checks for this files
    "LICENSE"

    # Ignore some files in the template directories
    "templates/**/LICENSE"
    "templates/**/.gitignore"
  ];

  # Scan Nix files for dead code
  # programs.deadnix.enable = true;

  # Our nix file formatter
  programs.alejandra.enable = true;

  # Justfile formatter
  programs.just.enable = true;

  # Format Markdown etc.
  programs.prettier.enable = true;

  # Python formatter (replacement for black)
  # programs.ruff.format = true;
  # programs.ruff.check = true;

  # Shell script checks
  # programs.shellcheck.enable = pkgs.hostPlatform.system != "riscv64-linux";
  # programs.shfmt.enable = pkgs.hostPlatform.system != "riscv64-linux";
}
