{
  rocq-core,
  mkRocqDerivation,
  lib,
  micromega-plugin,
  version ? null,
}:

let
  derivation = mkRocqDerivation {

    pname = "stdlib";
    repo = "stdlib";
    owner = "rocq-prover";
    opam-name = "rocq-stdlib";

    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with lib.versions;
      lib.switch rocq-core.version [
        (case (range "9.3" "9.3") "9.2.0")
        (case (range "9.2" "9.2") "9.1.0")
        (case (isLe "9.1") "9.0.0")
      ] null;
    releaseRev = v: "V${v}";

    release."9.0.0".sha256 = "sha256-2l7ak5Q/NbiNvUzIVXOniEneDXouBMNSSVFbD1Pf8cQ=";
    release."9.1.0".sha256 = "sha256-D/kCMsJDg5OnP37GhvXIr2Fi/xCbgCCzoikKx5rL6p4=";
    release."9.2.0".sha256 = "sha256-ySNY8XUQOH6B1B2p+39jdJ7UjIMrRDl499JJwpLEHuM=";

    mlPlugin = true;

    propagatedBuildInputs = [ ];

    meta = {
      description = "Rocq Proof Assistant -- Standard Library";
      license = lib.licenses.lgpl21Only;
    };

  };
  # the < 9.0 above is artificial as stdlib was included in Coq before
  patched-derivation1 = derivation.overrideAttrs (
    o:
    lib.optionalAttrs
      (rocq-core.rocq-version != "dev" && lib.versions.isLe "8.20" rocq-core.rocq-version)
      {
        configurePhase = ''
          echo no configuration
        '';
        buildPhase = ''
          echo building nothing
        '';
        installPhase = ''
          echo installing nothing
          # Make an output directory rather than a file, so this is more friendly to buildEnv
          mkdir $out
        '';
      }
  );
  patched-derivation2 = patched-derivation1.overrideAttrs (
    o:
    lib.optionalAttrs (o.version != null && (o.version == "dev" || lib.versions.isGe "9.3.0" o.version))
      {
        propagatedBuildInputs = o.propagatedBuildInputs ++ [ micromega-plugin ];
      }
  );
in
patched-derivation2
