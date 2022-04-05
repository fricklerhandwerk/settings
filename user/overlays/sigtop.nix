{ stdenv, fetchFromGitHub, openssl, pkg-config }:
stdenv.mkDerivation {
  name = "sigtop";
  version = "2022-03-21";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "069dd4d0526a795c00eb34dd1112637f6d8994a4";
    sha256 = "1gmxyjx7kbr2n33aq84ipa2pfhrdw7v7ggz01qd54nqyvp8hdbzs";
  };

  buildInputs = [ openssl pkg-config ];
  makeFlags = [
    "PREFIX=\${out}"
  ];
}
