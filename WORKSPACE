workspace(name = "pulsar-hs-repro")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_nixpkgs",
    strip_prefix = "rules_nixpkgs-81f61c4b5afcf50665b7073f7fce4c1755b4b9a3",
    urls = ["https://github.com/tweag/rules_nixpkgs/archive/81f61c4b5afcf50665b7073f7fce4c1755b4b9a3.tar.gz"],
    sha256 = "33fd540d0283cf9956d0a5a640acb1430c81539a84069114beaf9640c96d221a",
)

http_archive(
  name = "rules_haskell",
  strip_prefix = "rules_haskell-defcff74a72c2d21f7598e3505d286b5c2bb4694",
  urls = ["https://github.com/tweag/rules_haskell/archive/defcff74a72c2d21f7598e3505d286b5c2bb4694.tar.gz"],
  sha256 = "37509affc5ab80b422c16dcfcc1d86c492483f40cc5f6dfe62db0fba2cd2fc35",
)

load("@rules_nixpkgs//nixpkgs:repositories.bzl", "rules_nixpkgs_dependencies")
rules_nixpkgs_dependencies()

load("@rules_haskell//haskell:repositories.bzl", "rules_haskell_dependencies")
rules_haskell_dependencies()

load("@rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_local_repository", "nixpkgs_python_configure", "nixpkgs_package")
nixpkgs_local_repository(name = "nixpkgs", nix_file = "//:nixpkgs.nix")
nixpkgs_python_configure(repository = "@nixpkgs")

load("@rules_haskell//haskell:nixpkgs.bzl", "haskell_register_ghc_nixpkgs")
haskell_register_ghc_nixpkgs(
  version = "8.10.7",
  attribute_path = "compiler",
  repository = "@nixpkgs",
)

load("@rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_cc_configure")
nixpkgs_cc_configure(repository = "@nixpkgs")
