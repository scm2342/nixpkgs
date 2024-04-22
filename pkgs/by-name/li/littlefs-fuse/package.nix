{ lib, stdenv, fetchFromGitHub, fuse }:

stdenv.mkDerivation rec {
  pname = "littlefs-fuse";
  version = "2.7.7";
  src = fetchFromGitHub {
    owner = "littlefs-project";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MCmi0CBs3RLuYn+1BsS6pIeR/tHS1lGNyV3ZwlsnQCA=";
  };
  buildInputs = [ fuse ];
  installPhase = ''
    runHook preInstall
    install -D lfs $out/bin/${pname}
    ln -s $out/bin/${pname} $out/bin/mount.littlefs
    ln -s $out/bin $out/sbin
    runHook postInstall
  '';
  meta = src.meta // {
    description = "A FUSE wrapper that puts the littlefs in user-space";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "littlefs-fuse";
    inherit (fuse.meta) platforms;
    # fatal error: 'linux/fs.h' file not found
    broken = stdenv.isDarwin;
  };
}
