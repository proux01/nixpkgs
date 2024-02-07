{ lib, buildDunePackage, fetchurl
, ocaml, findlib, zarith, ocplib-simplex, csdp, autoconf
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "osdp is not available for OCaml ${ocaml.version}"

buildDunePackage {
  pname = "osdp";
  version = "1.1.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/proux01/osdp/archive/refs/heads/dune.tar.gz";
    hash = "sha256-xPTl3c+9PxRkNeEA7JEkhqyisuW1nJrs7eivkopJ/r4=";
  };

  preConfigure = ''
    autoconf
  '';

  nativeBuildInputs = [
    autoconf findlib csdp
  ];
  propagatedBuildInputs = [
    zarith ocplib-simplex csdp
  ];
  strictDeps = true;

  meta = {
    description = "OCaml Interface to SDP solvers";
    homepage = "https://github.com/Embedded-SW-VnV/osdp";
    license = lib.licenses.lgpl3Plus;
  };
}
