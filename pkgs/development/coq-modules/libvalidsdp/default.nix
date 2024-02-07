{ coq, mkCoqDerivation, mathcomp, bignums, flocq, coquelicot,
  interval, mathcomp-analysis, ocaml, autoconf, automake,
  lib, version ? null }:

mkCoqDerivation {

  pname = "libvalidsdp";
  repo = "validsdp";
  owner = "validsdp";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version mathcomp.version ]  [
      { cases = [ (range "8.16" "8.18") (isGe "2.0") ]; out = "master"; }
    ] null;

  # release."v1.0.2".sha256 = "sha256-I3v1lbzyS9MD7CXGyCStFKpUhAaxqM7DipSq25iOfmU=";

  nativeBuildInputs = [ ocaml autoconf automake ];
  propagatedBuildInputs = [ mathcomp.field bignums flocq coquelicot interval mathcomp-analysis ];

  preConfigure = ''
    cd libvalidsdp
    autoreconf -i -s
  '';

  meta = {
    description = "LibValidSDP";
    license = lib.licenses.lgpl21Plus;
  };
}
