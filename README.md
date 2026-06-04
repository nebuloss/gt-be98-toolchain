# gt-be98-toolchain

Prebuilt **external cross-toolchain** for the GT-BE98 router — the minimal set of
Broadcom ARM-HND crosstools the firmware build actually uses, packaged for
consumption by a Buildroot external toolchain (`BR2_TOOLCHAIN_EXTERNAL_CUSTOM`).

Part of the GT-BE98 repo family (see **[ARCHITECTURE.md](ARCHITECTURE.md)**):

| Repo | Role |
|------|------|
| `gt-be98-firmware`   | Current asuswrt-merlin SDK build (patches + scripts). Working today. |
| `gt-be98-buildroot`  | The Buildroot external tree (`BR2_EXTERNAL`) — migration target. |
| **`gt-be98-toolchain`** | **This repo — the prebuilt cross-toolchain.** |
| `gt-be98-packages`   | Proprietary/custom package sources + firmware blobs. |

> Note: this repo was initially pushed as `gt-be98-sources`. If the GitHub repo
> is still named that, rename it to `gt-be98-toolchain` (Settings → rename; old
> URLs redirect) or create a new `gt-be98-toolchain` remote.

## Contents

| Path | What |
|------|------|
| `toolchain/gt-be98-toolchain-brcm-arm-hnd-minimal.tar.gz` | The toolchain (423M). Unpacks to `brcm-arm-hnd/<crosstools-…>`. |
| `toolchain/MANIFEST.txt` | Included variants, sizes, tarball sha256. |
| `toolchain/README.md` | Which crosstools + why (empirically traced from a full build). |
| `scripts/make-toolchain-tarball.sh` | Reproducible generator. |

Only **4** of the upstream 9 crosstools variants are included (the ones the build
invokes): `arm_softfp-gcc-10.3`, `arm-gcc-5.5`, `aarch64-gcc-10.3`,
`arm-gcc-10.3`. Upstream `RMerl/am-toolchains` is 3.6G; this is 423M.

## Toolchain version (for the Buildroot external-toolchain config)

Derived from the crosstools directory names:

| Property | Value |
|----------|-------|
| Primary tuple | `arm-buildroot-linux-gnueabi` (ARM, softfp) |
| GCC | 10.3 |
| Binutils | 2.36.1 |
| C library | glibc 2.32 |
| Kernel headers | 4.19 |

> NB: the build is **mixed 32/64** — `arm_softfp-gcc-10.3` dominates (userspace +
> kernel) but `aarch64-gcc-10.3` is also invoked. Confirm the Buildroot
> `BR2_arm`/`BR2_aarch64` target split during migration (see gt-be98-buildroot).

## Hosting note (LFS → Releases)

The tarball is currently tracked with **Git LFS**. For Buildroot the better
long-term home is a **GitHub Release asset** — Buildroot fetches external
toolchains by URL (`BR2_TOOLCHAIN_EXTERNAL_URL`) and Releases avoid LFS bandwidth
quotas. See `scripts/upload-release.sh` and ARCHITECTURE.md → "Hosting".

## Regenerate

```bash
scripts/make-toolchain-tarball.sh \
    ../gt-be98-firmware/toolchain/am-toolchains/brcm-arm-hnd \
    ./toolchain
```
