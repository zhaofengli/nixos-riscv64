# We cheat a little bit by using the X86 version of node.js during
# build since a native build of node on RISC-V hangs for 48+ hours
# on node_mksnapshot (more investigation needed). Node.js is only
# used in the build process.

{ lib, pkgs, fetchurl }:

let
  x86Pkgs = import pkgs.path {
    system = "x86_64-linux";
    overlays = pkgs.overlays;
  };

  patchedSrc = pkgs.runCommand "firefox-${pkgs.firefox-unwrapped.version}-riscv64.source.tar.xz" {
    originalSrc = pkgs.firefox-unwrapped.src;
    nativeBuildInputs = with pkgs; [ python3 cargo git ];

    outputHashMode = "flat";
    outputHash = "sha256-5SKYhGEKVOtaiTUKQgz05eaixy3/SNa7nwbXU8TTxgc=";
  } ''
    >&2 echo "Unpacking source..."
    tar xf $originalSrc
    pushd firefox-*

    >&2 echo "Patching source..."
    patch -p1 < ${./riscv64-base.patch}

    >&2 echo "Updating vendor..."
    git init
    HOME=/tmp PYTHONDONTWRITEBYTECODE=1 python3 ./mach vendor rust --ignore-modified
    rm -rf .git obj*

    >&2 echo "Repacking source..."
    popd
    tar -caf $out --sort=name --owner=0 --group=0 --numeric-owner --format=gnu \
        --mtime=@0 --sort=name \
        firefox-*
  '';

  firefox = let
    ffOverride = pkgs.firefox-unwrapped.override {
      # FIXME: Haven't managed to build nodejs natively on RISC-V (stuck
      # on node_mksnapshot). Node.js is only used during build time.
      nodejs = x86Pkgs.nodejs;

      # 2:02.68(B DEBUG: | ld: error: conftest.8bh56oov.c:(.text+0x0): relocation R_RISCV_ALIGN requires unimplemented linker relaxation; recompile with -mno-relax(B
      ltoSupport = false;
    };
  in ffOverride.overrideAttrs (old: {
    # The only thing required here is to update authenticator-rs
    # for RISC-V support.
    src = patchedSrc;
  });
in firefox
