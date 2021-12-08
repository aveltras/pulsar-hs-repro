let
  pkgs = import ./nixpkgs.nix {};
  
in with pkgs; mkShell {
  packages = [
    bazel
    compiler
  ];
}
