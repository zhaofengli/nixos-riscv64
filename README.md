# NixOS on the HiFive Unmatched

Work in progress.
I'm using [this Nixpkgs tree](https://github.com/zhaofengli/nixpkgs/tree/riscv) with oxalica's bootstrap binaries from [this PR](https://github.com/NixOS/nixpkgs/pull/115406).

## U-Boot

Build `pkgs.unmatched.uboot`.

You need to create two GPT partitions on the SD card with the following sizes and GUIDs:

- 1MiB `5b193300-fc78-40cd-8002-e86c45580b47` (HiFive Unleashed FSBL)
- 4MiB `2e54b353-1271-4842-806f-e436d6af6985` (HiFive Unleashed BBL)

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
