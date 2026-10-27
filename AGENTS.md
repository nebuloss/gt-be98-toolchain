# AGENTS.md: gt-be98-toolchain

Prebuilt Broadcom ARM-HND cross-toolchains (GCC 10.3, glibc 2.32, binutils
2.36.1, 4.19 headers) for the **legacy merlin 4.19** builds, published as
GitHub Release assets. The mainline OS (gt-be98-buildroot
`gt-be98_mainline_defconfig`) builds its own toolchain and uses none of this.

## Release tags and who consumes them

Measured with `git ls-remote --tags` (both tags point at `master`'s commit),
the GitHub releases API and the consumers' files.

| tag | asset | consumed by | checksum pinned by the consumer |
|---|---|---|---|
| `arm_softfp-gcc10.3` | `gt-be98-toolchain-arm_softfp-gcc10.3.tar.gz` | gt-be98-buildroot legacy defconfigs (`gt-be98_defconfig`, `_full`, `_fromsrc`, `_openrc-init`, `_pkgtest`) via `BR2_TOOLCHAIN_EXTERNAL_URL`, on every branch; also selectable in gt-be98-kernel `scripts/fetch-toolchain.sh` | **none** (no hash file in buildroot; the kernel script has it unpinned) |
| `aarch64-gcc10.3` | `gt-be98-toolchain-aarch64-gcc10.3.tar.gz` | gt-be98-kernel `scripts/fetch-toolchain.sh` (`TC_FROM_RELEASE=1`) | sha256, matches the asset |

gt-be98-open-wifi's 4.19 module build does **not** use these releases: its
`driver/Makefile` defaults to the toolchain inside the build host's
gt-be98-firmware checkout.

A tag that a consumer names must never move or be deleted, and its asset must
never be replaced: the URL is the pin. Publish a new tag instead.

## What is in git

- `toolchain/gt-be98-toolchain-brcm-arm-hnd-minimal.tar.gz`: the 4-variant
  tarball as a **Git LFS** pointer (`.gitattributes` LFS-tracks `*.tar.*`).
  It cannot be used by Buildroot download mode (nested layout).
- `scripts/make-toolchain-tarball.sh` (the 4-variant tarball),
  `scripts/make-buildroot-toolchain-tarball.sh` (one variant, the layout the
  release assets use), `scripts/upload-release.sh`.
- `toolchain/MANIFEST.txt`, `toolchain/README.md`: variants, sizes, why these
  four.

Regenerating needs the full toolchain of a gt-be98-firmware checkout
(`toolchain/am-toolchains/brcm-arm-hnd`), so it runs on the build host only.
Publishing a release is the owner's call.

## Rules

- Public repository: no IP addresses, MACs, user names, host names,
  passphrases, keys or e-mail addresses. Never commit an extracted toolchain
  or a tarball outside LFS. `dist/` (the release-asset build output) is not
  in `.gitignore`: never add it.
- Never build on the dev machine. `master` is the default branch; work on
  `<topic>-<YYYY-MM-DD>`, never force-push, never push to `master`, never
  `git add -A`.
- `docs/device` is a submodule (gt-be98-docs). The architecture overview of
  the repo family is gt-be98-buildroot's `ARCHITECTURE.md`.
