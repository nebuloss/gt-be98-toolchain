#!/usr/bin/env bash
# Upload the minimal toolchain tarball as a GitHub Release asset (preferred over
# Git LFS for Buildroot, which fetches BR2_TOOLCHAIN_EXTERNAL_URL by URL).
#
# Requires the `gh` CLI authenticated against the gt-be98-toolchain repo.
#   ./scripts/upload-release.sh [TAG]
# Default TAG derives from the toolchain version in the tarball name.
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
TARBALL="${HERE}/toolchain/gt-be98-toolchain-brcm-arm-hnd-minimal.tar.gz"
TAG="${1:-brcm-arm-hnd-gcc10.3-glibc2.32}"

[[ -f "$TARBALL" ]] || { echo "ERROR: tarball missing: $TARBALL (run make-toolchain-tarball.sh)" >&2; exit 1; }
command -v gh >/dev/null || { echo "ERROR: gh CLI not installed/authenticated" >&2; exit 1; }

SHA="$(sha256sum "$TARBALL" | cut -d' ' -f1)"
echo "Tag    : $TAG"
echo "Asset  : $(basename "$TARBALL") ($(du -h "$TARBALL" | cut -f1))"
echo "sha256 : $SHA"

# Create the release (idempotent: ignore if it already exists) and upload.
gh release view "$TAG" >/dev/null 2>&1 \
    || gh release create "$TAG" --title "GT-BE98 toolchain ($TAG)" \
         --notes "Minimal Broadcom ARM-HND cross-toolchain (4 crosstools). sha256: ${SHA}"
gh release upload "$TAG" "$TARBALL" --clobber

echo
echo "Release URL for Buildroot BR2_TOOLCHAIN_EXTERNAL_URL:"
echo "  https://github.com/nebuloss/gt-be98-toolchain/releases/download/${TAG}/$(basename "$TARBALL")"
echo
echo "After this, consider 'git rm --cached' the LFS copy and drop it from"
echo ".gitattributes so the repo no longer carries the blob."
