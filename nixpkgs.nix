let
  githubTarball = owner: repo: rev:
    builtins.fetchTarball { url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"; };

  nixpkgsSrc = commit:
    githubTarball "NixOS" "nixpkgs" commit;

  localOverlays = [

    # make ghc8107 the default package set for haskell
    (self: super: let
      pulsarHsSrc = githubTarball "hetchr" "pulsar-hs" "a3cdf80b82019a8e86f38551faebce82cae9f136";
      pulsarHs = import "${pulsarHsSrc}/pulsar-client-hs" { nixpkgs = super; compiler = "ghc8107";};
    in {
      # to see the versions of the packages currently in use
      # visit https://raw.githubusercontent.com/NixOS/nixpkgs/${NIXPKGS_COMMIT_HERE}/pkgs/development/haskell-modules/hackage-packages.nix
      haskellPackages = super.haskell.packages.ghc8107.override {
        overrides = hself: hsuper: {
          pulsar-client-hs = pulsarHs.pulsar-client-hs;
        };
      };
    })
    
    # override ghc adding all project dependencies as toolchain packages
    (self: super: {
      compiler = super.haskellPackages.ghcWithPackages (p: with p; [
        base
        bytestring
        pulsar-client-hs
        resourcet
        transformers
      ]);
    })
  ];

in args@{ overlays ? [], commit ? "b5182c214fac1e6db9f28ed8a7cfc2d0c255c763", ... }:
  import (nixpkgsSrc commit) (args // {
    overlays = localOverlays ++ overlays;
  })
