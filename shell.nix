{ nixpkgs ? import <nixpkgs> {}
}:
nixpkgs.stdenv.mkDerivation {
  name = "lyah-fr";
  buildInputs = (with nixpkgs; [
    haskellPackages.hscolour
    haskellPackages.pandoc
    pdftk
    python39Packages.weasyprint
  ]);
  nativeBuildInputs = (with nixpkgs; [
  ]);
  shellHook = ''
    export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
    export PATH=`pwd`/node_modules/.bin:$PATH
  '';
}
