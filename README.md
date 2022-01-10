# NixOS on RISC-V

This repo contains board-specific packages to get NixOS running on RISC-V platforms.
I'm using [this Nixpkgs tree](https://github.com/zhaofengli/nixpkgs/tree/riscv).

For the HiFive Unmatched, include `nixos/unmatched.nix` in your NixOS configuration.

## Is it booting?

Yes! More details [here](https://github.com/NixOS/nixpkgs/issues/101651#issuecomment-852725823).

![Screenshot of pfetch output on the HiFive Unmatched in a terminal](./imgs/riesgo-firstboot.png)

## Binary cache

A binary cache is available [here](https://app.cachix.org/cache/unmatched), with all packages in `binary-cache/world.nix` cached.
Note that all binaries here are built against [my riscv-cached branch](https://github.com/zhaofengli/nixpkgs/tree/riscv-cached).

Use the following configurations:
```
substituters = https://cache.nixos.org https://unmatched.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= unmatched.cachix.org-1:F8TWIP/hA2808FDABsayBCFjrmrz296+5CQaysosTTc=
```

## U-Boot

Build `pkgs.unmatched.uboot`.

You need to create two GPT partitions on the SD card with the following sizes and GUIDs:

- 1MiB `5b193300-fc78-40cd-8002-e86c45580b47` (HiFive Unleashed FSBL)
- 4MiB `2e54b353-1271-4842-806f-e436d6af6985` (HiFive Unleashed BBL)

The easiest way to do this is with this command (you need `pkgs.gptfdisk`):

```
sgdisk -g --clear --set-alignment=1 \
    --new=1:34:+1M: --typecode=1:5b193300-fc78-40cd-8002-e86c45580b47 \
    --new=2:2082:+4M: --typecode=2:2e54b353-1271-4842-806f-e436d6af6985 \
    [block device]
```

Write the bootloader to the SD card as follows:

```
# FSBL
dd if=result/u-boot-spl.bin of=/dev/mmcblk0p1 bs=4k oflag=direct

# SBL
dd if=result/u-boot.itb of=/dev/mmcblk0p2 bs=4k oflag=direct
```

## References

- https://github.com/carlosedp/riscv-bringup/tree/master/unmatched
- https://github.com/NixOS/nixpkgs/pull/115406

## See Also

There are other efforts to bring NixOS to RISC-V:

- https://github.com/NickCao/nixos-riscv
- https://github.com/ius/jh7100
