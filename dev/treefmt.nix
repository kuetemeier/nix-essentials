{
  # Used to find the project root
  projectRootFile = "flake.lock";

  # Scan Nix files for dead code
  # programs.deadnix.enable = true;

  # Our nix file formatter
  programs.alejandra.enable = true;

  # Justfile formatter
  programs.just.enable = true;

  programs.prettier.enable = true;

  # programs.markdown.enable = true;

  # Python formatter (replacement for black)
  # programs.ruff.format = true;
  # programs.ruff.check = true;
}
