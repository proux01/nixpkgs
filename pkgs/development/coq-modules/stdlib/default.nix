{ coq, mkCoqDerivation, lib, version ? null }@args:
(mkCoqDerivation {

  pname = "stdlib";
  repo = "stdlib-test";
  owner = "coq-community";
  opam-name = "coq-stdlib";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version ] [
      { cases = [ (isLt "8.21") ]; out = "master"; }
    ] null;

#  release."1.2.0".sha256 = "sha256-w6BivDM4dF4Iv4rUTy++2feweNtMAJxgGExPfYGhXxo=";

  useDune = true;

  meta = {
    description = "Coq Standard Library";
    license = lib.licenses.lgpl21Only;
  };

}).overrideAttrs (o:
  # stdlib is already included in Coq <= 8.20
  lib.optionalAttrs (coq.version != null && coq.version != "dev" && lib.versions.isLt "8.21" coq.version)
   { preBuild = "touch empty.v; echo empty.v > Make.all; echo '-R . StdlibIsPartOfCoq' > Make.all"; })
