{ lib, buildPythonPackage, fetchPypi, fetchpatch, isPy27
, mock, pytest, sybil, zope_component, twisted }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14d9907390f5f9c7189b3d511b64f34f1072d07cc13b604a57e1bb79029376e3";
  };

  checkInputs = [ pytest mock sybil zope_component twisted ];

  doCheck = !isPy27;
  checkPhase = ''
    # django is too much hasle to setup at the moment
    pytest -W ignore::DeprecationWarning \
      --ignore=testfixtures/tests/test_django \
      -k 'not (log_then_patch or our_wrap_dealing_with_mock_patch or patch_with_dict)' \
      testfixtures/tests
  '';

  meta = with lib; {
    homepage = "https://github.com/Simplistix/testfixtures";
    description = "A collection of helpers and mock objects for unit tests and doc tests";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
