#!/usr/bin/env bash
# Repackage ONE crosstools variant into a tarball that Buildroot's external
# toolchain DOWNLOAD mode can consume directly (BR2_TOOLCHAIN_EXTERNAL_URL).
#
# Buildroot extracts the tarball with --strip-components=1, then expects a
# bin/<prefix>-gcc at the root. So the tarball must have a SINGLE top-level
# directory (the crosstools dir) wrapping bin/, lib/, libexec/, and the
# <tuple>/sysroot tree. The crosstools dir already has exactly that shape, and
# it carries Buildroot's relocatable toolchain-wrapper (*.br_real), which
# Buildroot auto-detects and bypasses.
#
# The 4-in-1 minimal tarball (gt-be98-toolchain-brcm-arm-hnd-minimal.tar.gz)
# CANNOT be used for download mode because of its nested brcm-arm-hnd/<variant>/
# layout — hence this single-variant repackage.
#
# Usage:
#   scripts/make-buildroot-toolchain-tarball.sh [SRC_CROSSTOOLS_DIR] [OUT_DIR]
#
#   SRC_CROSSTOOLS_DIR  path to a single crosstools-... dir whose bin/ holds
#                       <tuple>-gcc (default: the arm_softfp primary variant in
#                       the sibling gt-be98-firmware extraction)
#   OUT_DIR             where to write the tarball (default: ./dist)
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
DEFAULT_SRC="${HERE}/../gt-be98-firmware/toolchain/am-toolchains/brcm-arm-hnd/crosstools-arm_softfp-gcc-10.3-linux-4.19-glibc-2.32-binutils-2.36.1"
SRC="${1:-$DEFAULT_SRC}"
OUT_DIR="${2:-${HERE}/dist}"

[[ -d "$SRC" ]] || { echo "ERROR: crosstools dir not found: $SRC" >&2; exit 1; }
PREFIX="$(cd "$SRC/bin" && ls *-gcc 2>/dev/null | grep -E -- '-gcc$' | grep -v '\.br_real' | head -1 | sed 's/-gcc$//')"
[[ -n "$PREFIX" ]] || { echo "ERROR: no <tuple>-gcc in $SRC/bin" >&2; exit 1; }

VARIANT="$(basename "$SRC")"
# e.g. crosstools-arm_softfp-gcc-10.3-... -> gt-be98-toolchain-arm_softfp-gcc10.3
SHORT="$(echo "$VARIANT" | sed -E 's/^crosstools-//; s/-linux-.*$//; s/-gcc-/-gcc/')"
TARBALL="${OUT_DIR}/gt-be98-toolchain-${SHORT}.tar.gz"

mkdir -p "$OUT_DIR"
echo "Source  : $SRC"
echo "Tuple   : $PREFIX"
echo "Tarball : $TARBALL"
echo "Packing (single top-level dir = $VARIANT) ..."
if command -v pigz >/dev/null 2>&1; then GZ=pigz; else GZ=gzip; fi
# Top-level component = the crosstools dir, so --strip-components=1 lands bin/ at root.
tar -C "$(dirname "$SRC")" -cf - "$VARIANT" | "$GZ" > "$TARBALL"

SHA="$(sha256sum "$TARBALL" | cut -d' ' -f1)"
echo
echo "Done:"
echo "  $TARBALL ($(du -h "$TARBALL" | cut -f1))"
echo "  sha256: $SHA"
echo
echo "Wire into the Buildroot defconfig (after uploading as a Release asset):"
echo "  BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y"
echo "  BR2_TOOLCHAIN_EXTERNAL_URL=\"https://github.com/nebuloss/gt-be98-toolchain/releases/download/<tag>/$(basename "$TARBALL")\""
echo "  BR2_TOOLCHAIN_EXTERNAL_CUSTOM_PREFIX=\"$PREFIX\""
echo
echo "Local test without uploading:"
echo "  BR2_TOOLCHAIN_EXTERNAL_URL=\"file://$TARBALL\""
