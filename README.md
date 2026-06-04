# gt-be98-sources

Source/blob repository backing the **GT-BE98** firmware — the place for large,
prebuilt or vendored artifacts that don't belong in the lean
[`gt-be98-firmware`](../gt-be98-firmware) tree (which holds only patches, build
scripts, and docs).

The long-term intent is to seed a **Buildroot external tree**: custom package
sources and the external cross-toolchain live here, while `gt-be98-firmware`
(or a future buildroot config) references them.

## Layout

| Path | Contents |
|------|----------|
| `toolchain/` | Minimal GT-BE98 cross-toolchain tarball + manifest (the prebuilt external toolchain). |
| `scripts/`   | Reproducible generators (e.g. `make-toolchain-tarball.sh`). |

## Large files

Binary blobs (`*.tar.gz`, `*.tar.zst`, `*.tar.xz`) are tracked with **Git LFS**
(see `.gitattributes`). Clone with `git lfs install` configured, or fetch blobs
lazily with `git lfs pull`.

## Toolchain

The upstream `RMerl/am-toolchains` checkout is ~3.6G (9 cross-compiler variants
+ an unused SDK tree + git history). The GT-BE98 build only invokes **four**
variants. `scripts/make-toolchain-tarball.sh` extracts just those into
`toolchain/gt-be98-toolchain-brcm-arm-hnd-minimal.tar.gz`. See
`toolchain/README.md` for details and provenance.
