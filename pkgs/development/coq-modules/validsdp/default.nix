{ coq, mkCoqDerivation, mathcomp, bignums, paramcoq, flocq,
  interval, mathcomp-analysis, ocaml, autoconf, automake,
  libvalidsdp, multinomials, coqeal, ocamlPackages,
  lib, version ? null }:

mkCoqDerivation {

  pname = "validsdp";
  repo = "validsdp";
  owner = "validsdp";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version mathcomp.version ]  [
      { cases = [ (range "8.16" "8.18") (isGe "2.0") ]; out = "master"; }
    ] null;

  # release."v1.0.2".sha256 = "sha256-I3v1lbzyS9MD7CXGyCStFKpUhAaxqM7DipSq25iOfmU=";

  nativeBuildInputs = [ ocamlPackages.findlib ocaml autoconf automake ];
  propagatedBuildInputs = [ mathcomp.field bignums flocq interval mathcomp-analysis libvalidsdp multinomials coqeal paramcoq ocamlPackages.osdp ocamlPackages.ocplib-simplex ];

  preConfigure = ''
    autoreconf -i -s
  '';
  postConfigure = ''
    sed -i Makefile.coq.local -e 's/-package ocplib-simplex/-package logs -package ocplib-simplex/'
    sed -i Makefile -e 's/ocplibSimplex.cmxa/logs.cmxa OcplibSimplex.cmxa/'
  '';

  postInstall = ''
    make "test"
  '';

  meta = {
    description = "ValidSDP";
    license = lib.licenses.lgpl21Plus;
  };
}
