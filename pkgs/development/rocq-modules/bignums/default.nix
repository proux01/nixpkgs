{
  lib,
  mkRocqDerivation,
  rocq,
  stdlib,
  version ? null,
}:

mkRocqDerivation {
  pname = "bignums";
  owner = "coq";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch rocq.rocq-version [
      {
        case = range "8.13" "8.20";
        out = "9.0.0+coq${rocq.rocq-version}";
      }
      {
        case = range "8.6" "8.17";
        out = "${rocq.rocq-version}.0";
      }
    ] "master";

  release."9.0.0+coq8.20".sha256 = "sha256-pkvyDaMXRalc6Uu1eBTuiqTpRauRrzu946c6TavyTKY=";
/*  releaseRev = v: "${if lib.versions.isGe "9.0" v then "v" else "V"}${v}"; */

  mlPlugin = true;

  propagatedBuildInputs = [ stdlib ];

  meta = {
    license = lib.licenses.lgpl2;
  };
}
