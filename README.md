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

`theme/` holds the Homestead look as system defaults, and `wallpapers/` the wallpapers
(most are other artists' work, published as-is). The Artix repo
[zpt-artix](https://github.com/ztancrell/zpt-artix) packages them as `homestead-theme` and
`homestead-wallpapers`:

| `theme/` | Installed to |
|---|---|
| `themes/Homestead` (GTK 3/4, Openbox) | `/usr/share/themes/Homestead` |
| `icons/{Homestead,Homestead-Cursor,KDE-classic}` | `/usr/share/icons/` |
| `gtk-3.0/settings.ini`, `gtk-4.0/settings.ini` | `/etc/gtk-3.0/`, `/etc/gtk-4.0/` |
| `openbox/{autostart,rc.xml,menu.xml,environment}` | `/etc/xdg/openbox/` |
| `tint2/tint2rc`, `kitty/`, `obmenu-generator/` | `/etc/xdg/tint2/`, `/etc/xdg/kitty/`, `/etc/xdg/obmenu-generator/` |
| `sounds/`, `scripts/` | `/usr/share/homestead/` |
| `../wallpapers/` | `/usr/share/backgrounds/homestead/` |

They are my `~/.config` files made machine-neutral: no monitor layout (xrandr), Synergy or
redshift script, paths under `/usr/share/homestead`, `loginctl suspend`, and the cursor set by
`XCURSOR_THEME` in the Openbox `environment`. Files in `~/.config` still override them.

`notes/` holds investigation notes. `synergy/` holds my Synergy 3 setup (desktop shares
keyboard/mouse with a MacBook Pro 2019, macOS + Boot Camp). `CLAUDE.md` has build details and how a change gets shipped.

```sh
git clone --recurse-submodules https://github.com/ztancrell/homestead.git
```
