{ lib, stdenv, fetchurl, fetchzip
, callPackage, newScope, recurseIntoAttrs, ocamlPackages_4_14
, fetchpatch, makeWrapper,
}@args:
let lib = import ../build-support/rocq/extra-lib.nix {inherit (args) lib;}; in
let
  mkRocqPackages' = self: rocq:
    let callPackage = self.callPackage; in {
      inherit rocq lib;
      rocqPackages = self // { __attrsFailEvaluation = true; recurseForDerivations = false; };

      metaFetch = import ../build-support/rocq/meta-fetch/default.nix
        {inherit lib stdenv fetchzip fetchurl; };
      mkRocqDerivation = lib.makeOverridable (callPackage ../build-support/rocq {});

      stdlib = callPackage ../development/rocq-modules/stdlib {};

      filterPackages = doesFilter: if doesFilter then filterRocqPackages self else self;
    };

  filterRocqPackages = set:
    lib.listToAttrs (
      lib.concatMap (name: let v = set.${name} or null; in
          lib.optional (! v.meta.rocqFilter or false)
            (lib.nameValuePair name (
              if lib.isAttrs v && v.recurseForDerivations or false
              then filterRocqPackages v
              else v))
      ) (lib.attrNames set)
    );
  mkRocq = version: callPackage ../applications/science/logic/rocq {
    inherit version
      ocamlPackages_4_14
    ;
  };
in rec {

  /* The function `mkRocqPackages` takes as input a derivation for Rocq and produces
   * a set of libraries built with that specific Rocq. More libraries are known to
   * this function than what is compatible with that version of Rocq. Therefore,
   * libraries that are not known to be compatible are removed (filtered out) from
   * the resulting set. For meta-programming purposes (inpecting the derivations
   * rather than building the libraries) this filtering can be disabled by setting
   * a `dontFilter` attribute into the Rocq derivation.
   */
  mkRocqPackages = rocq:
    let self = lib.makeScope newScope (lib.flip mkRocqPackages' rocq); in
    self.filterPackages (! rocq.dontFilter or false);

  rocq_dev  = mkRocq "master";

  rocqPackages_dev = mkRocqPackages rocq_dev;

  rocqPackages = recurseIntoAttrs rocqPackages_dev;
  rocq = rocqPackages.rocq;
}
