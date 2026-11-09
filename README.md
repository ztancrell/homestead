# homestead

My patched X11 desktop stack, running daily on CachyOS. It is installed as pacman packages
built from these forks by [zpt-cachy](https://github.com/ztancrell/zpt-cachy) (`zpt-cachy-desktop`).
Each component is its own fork, tracked here as a git submodule.

| Component | Fork | What it is |
|---|---|---|
| `xserver` | [ztancrell/xserver](https://github.com/ztancrell/xserver) | [XLibre](https://github.com/X11Libre/xserver) X server |
| `xf86-input-libinput` | [ztancrell/xf86-input-libinput](https://github.com/ztancrell/xf86-input-libinput) | libinput input driver |
| `openbox` | [ztancrell/openbox-patchwork](https://github.com/ztancrell/openbox-patchwork) | Openbox window manager |
| `fastcompmgr` | [ztancrell/fastcompmgr](https://github.com/ztancrell/fastcompmgr) | compositor |
| `tint2` | [ztancrell/tint2](https://github.com/ztancrell/tint2) | panel |

`notes/` holds investigation notes. `synergy/` holds my Synergy 3 setup (desktop shares
keyboard/mouse with a MacBook Pro 2019, macOS + Boot Camp). `CLAUDE.md` has build details and how a change gets shipped.

```sh
git clone --recurse-submodules https://github.com/ztancrell/homestead.git
```
