# homestead

My patched X11 desktop stack, built from source and running daily on CachyOS.
Each component is its own fork, tracked here as a git submodule.

| Component | Fork | What it is |
|---|---|---|
| `xserver` | [ztancrell/xserver](https://github.com/ztancrell/xserver) | [XLibre](https://github.com/X11Libre/xserver) X server |
| `xf86-input-libinput` | [ztancrell/xf86-input-libinput](https://github.com/ztancrell/xf86-input-libinput) | libinput input driver |
| `xf86-video-amdgpu` | [ztancrell/xf86-video-amdgpu](https://github.com/ztancrell/xf86-video-amdgpu) | AMDGPU video driver (built, not in use; X runs `modesetting`) |
| `openbox` | [ztancrell/openbox-patchwork](https://github.com/ztancrell/openbox-patchwork) | Openbox window manager |
| `fastcompmgr` | [ztancrell/fastcompmgr](https://github.com/ztancrell/fastcompmgr) | compositor |
| `tint2` | [ztancrell/tint2](https://github.com/ztancrell/tint2) | panel |

`notes/` holds investigation notes. `CLAUDE.md` has build and install details.

```sh
git clone --recurse-submodules https://github.com/ztancrell/homestead.git
```
