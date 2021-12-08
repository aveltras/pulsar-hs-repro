let
  githubTarball = owner: repo: rev:
    builtins.fetchTarball { url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"; };

  nixpkgsSrc = commit:
    githubTarball "NixOS" "nixpkgs" commit;

  localOverlays = [

    (self: super: let
      pulsarHsSrc = githubTarball "hetchr" "pulsar-hs" "a3cdf80b82019a8e86f38551faebce82cae9f136";
      pulsarHs = import "${pulsarHsSrc}/pulsar-client-hs" { nixpkgs = super; compiler = "ghc8107";};
    in {
      haskellPackages = super.haskell.packages.ghc8107.override {
        overrides = hself: hsuper: let
          polysemySrc = githubTarball "polysemy-research" "polysemy" "v1.7.0.0";
        in {
          polysemy = self.haskell.lib.unmarkBroken (hsuper.callCabal2nix "polysemy" polysemySrc {});
          polysemy-plugin = self.haskell.lib.unmarkBroken (hsuper.callCabal2nix "polysemy-plugin" "${polysemySrc}/polysemy-plugin" {});
          pulsar-client-hs = pulsarHs.pulsar-client-hs;
        };
      };
    })
    
    # override ghc adding all project dependencies as toolchain packages
    (self: super: {
      compiler = super.haskellPackages.ghcWithPackages (p: with p; [
        base
        polysemy
        polysemy-plugin
        pulsar-client-hs
      ]);
    })
  ];

in args@{ overlays ? [], commit ? "b5182c214fac1e6db9f28ed8a7cfc2d0c255c763", ... }:
  import (nixpkgsSrc commit) (args // {
    overlays = localOverlays ++ overlays;
  })
