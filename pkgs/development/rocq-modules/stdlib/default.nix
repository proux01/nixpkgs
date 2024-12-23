{
  rocq,
  mkRocqDerivation,
  lib,
  version ? null,
}:
mkRocqDerivation {

  pname = "stdlib";
  repo = "stdlib";
  owner = "coq";
  opam-name = "rocq-stdlib";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch
      [ rocq.version ]
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

  configurePhase = ''
    patchShebangs dev/with-rocq-wrap.sh
  '';

  buildPhase = ''
    dev/with-rocq-wrap.sh dune build -p rocq-stdlib @install ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
  '';

  installPhase = ''
    dev/with-rocq-wrap.sh dune install --root . rocq-stdlib --prefix=$out --libdir $OCAMLFIND_DESTDIR
    mkdir $out/lib/coq/
    mv $OCAMLFIND_DESTDIR/coq $out/lib/coq/${rocq.rocq-version}
  '';

  meta = {
    description = "Rocq Standard Library";
    license = lib.licenses.lgpl21Only;
  };

}
