# GT-BE98 minimal cross-toolchain

A clean, minimal extract of the Broadcom ARM-HND cross-toolchain — only the
variants the GT-BE98 firmware build actually uses.

## Provenance

- Upstream: `https://github.com/RMerl/am-toolchains` (branch `master`), subtree
  `brcm-arm-hnd/`.
- The full upstream checkout ships **9** crosstools variants (~2.7G) plus an
  unused `brcm-arm-sdk` tree (~423M) and full git history (~total 3.6G).

## What's included (and why)

Determined empirically from a full GT-BE98 build log
(`grep -oE 'crosstools-[a-z0-9_.-]+' | sort | uniq -c`):

| Variant | Build invocations | Role |
|---------|------------------:|------|
| `crosstools-arm_softfp-gcc-10.3-linux-4.19-glibc-2.32-binutils-2.36.1` | ~11,900 | primary userspace + kernel (ARM softfp) |
| `crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1`          | ~8,400  | bootloader / legacy components |
| `crosstools-aarch64-gcc-10.3-linux-4.19-glibc-2.32-binutils-2.36.1`    | ~160    | 64-bit components |
| `crosstools-arm-gcc-10.3-linux-4.19-glibc-2.32-binutils-2.36.1`        | ~25     | misc ARM (gcc 10.3 hardfp) |

The other 5 variants and `brcm-arm-sdk` are **not referenced** by the GT-BE98
build and are excluded.

## Tarball

- `gt-be98-toolchain-brcm-arm-hnd-minimal.tar.gz` — unpacks to `brcm-arm-hnd/<crosstools-…>`,
  a drop-in for `gt-be98-firmware/toolchain/am-toolchains/`.
- `MANIFEST.txt` — included variants, sizes, and the tarball sha256.

## Regenerate

```bash
# from a full am-toolchains checkout (e.g. an existing gt-be98-firmware build):
scripts/make-toolchain-tarball.sh \
    ../gt-be98-firmware/toolchain/am-toolchains/brcm-arm-hnd \
    ./toolchain
```

Update the `REQUIRED` list in the script if an SDK bump changes which compilers
the build invokes.
