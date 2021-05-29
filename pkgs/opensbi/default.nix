{ lib, stdenv, fetchFromGitHub, unmatched }:

stdenv.mkDerivation rec {
  pname = "opensbi";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "opensbi";
    rev = "v${version}";
    sha256 = "1pw039zs02bjzlzbqr0g7bvdsqzs1vlpmgq56zrcs87c27am2zsv";
  };

  patches = unmatched.metaSifive.opensbiPatches;

  hardeningDisable = [ "all" ];

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "PLATFORM=generic"
    "I=$(out)"
  ];

  meta = with lib; {
    description = "RISC-V Open Source Supervisor Binary Interface";
    homepage = "https://github.com/riscv/opensbi";
    license = licenses.bsd2;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = [ "riscv64-linux" ];
  };
}
