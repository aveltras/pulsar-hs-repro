let
  pkgs = import ./nixpkgs.nix {};
  
in pkgs.haskellPackages.shellFor {
  packages = p: [p.pulsar-hs-repro];
  buildInputs = with pkgs; [
    cabal-install
    haskellPackages.ghc
  ];
}
