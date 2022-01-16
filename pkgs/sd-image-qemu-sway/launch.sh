#!/usr/bin/env bash

set -euo pipefail

BASE=$(dirname $0)

QEMU=qemu-system-riscv64
USERDISK=nixos-riscv64-qemu.raw
ORIGDISK=$(ls $BASE/sd-image/*.zst)
UBOOT=$(ls $BASE/u-boot.bin)

check_command() {
	if ! command -v $1 &>/dev/null 2>&1; then
		>&2 echo "$1 is required to run this. Try \"nix-shell -p qemu -p zstd\"."
		exit 1
	fi
}

check_command $QEMU
check_command qemu-img
check_command zstdcat

if [ ! -e $USERDISK ]; then
	>&2 echo "Creating a persistent disk image at $USERDISK..."
	zstdcat $ORIGDISK > $USERDISK
fi

>&2 echo "Launching QEMU..."

set -x
exec $QEMU -M virt -cpu rv64 -m 2G -smp 4 \
	-kernel $UBOOT \
	-display gtk,gl=on \
	-device qemu-xhci \
	-device virtio-vga-gl -device usb-tablet -device virtio-keyboard \
	-device intel-hda -device hda-duplex,audiodev=pa -audiodev pa,id=pa \
	-device virtio-blk-device,drive=sdimage \
	-drive file=$USERDISK,format=raw,id=sdimage \
	-device virtio-net-device,netdev=usernet \
	-netdev user,id=usernet,net=10.0.0.0/24,dhcpstart=10.0.0.10
