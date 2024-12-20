{
  coq,
  mkCoqDerivation,
  lib,
  version ? null,
}:
(mkCoqDerivation {

  pname = "stdlib";
  repo = "stdlib";
  owner = "coq";
  opam-name = "coq-stdlib";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch
      [ coq.version ]
      [
        {
          cases = [ (isLt "8.21") ];
          out = "master";
        }
      ]
      "master";
/*  releaseRev = v: "v${v}"; */

  release."8.20".sha256 = "sha256-AcoS4edUYCfJME1wx8UbuSQRF3jmxhArcZyPIoXcfu0=";

  useDune = true;

  meta = {
    description = "Coq Standard Library (metapackage)";
    license = lib.licenses.lgpl21Only;
  };

}).overrideAttrs
  (
    o:
    # stdlib is already included in Coq <= 8.20
    if coq.version != null && coq.version != "dev" && lib.versions.isLt "8.21" coq.version then {
      buildPhase = ''
        echo building nothing
      '';
      installPhase = ''
        touch $out
      '';
    } else { propagatedBuildInputs = [ coq.rocqPackages.stdlib ]; }
  )
