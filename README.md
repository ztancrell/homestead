# homestead

My patched X11 desktop stack, running daily on Artix Linux (OpenRC). It is installed as pacman packages
built from these forks by [zpt-artix](https://github.com/ztancrell/zpt-artix) (`zpt-artix-desktop`).
Superseded (2026-11-21): on CachyOS it was packaged by zpt-cachy (GitHub repo deleted 2026-11-23).
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
| `dunst/50-homestead.conf` | `/etc/dunst/dunstrc.d/` |
| `fastfetch/config.jsonc` | `/etc/xdg/fastfetch/` |
| `kde/kdeglobals`, `kde/Homestead.colors` | `/etc/xdg/kdeglobals`, `/usr/share/color-schemes/` |
| `sounds/`, `scripts/` | `/usr/share/homestead/` |
| `../wallpapers/` | `/usr/share/backgrounds/homestead/` |

They are my `~/.config` files made machine-neutral: no monitor layout (xrandr), Synergy or
redshift script, paths under `/usr/share/homestead`, `loginctl suspend`, and the cursor set by
`XCURSOR_THEME` in the Openbox `environment`. Files in `~/.config` still override them.
The autostart starts tint2 with `$HOMESTEAD_TINT2RC` when it is set, and the `environment` keeps
an `XCURSOR_SIZE` set before it (24 otherwise); zpt-artix's `homestead-hidpi` sets both.
The volume, screen brightness and keyboard backlight keys in `rc.xml` run
`scripts/homestead-osd` (`volume up|down|mute`, `brightness up|down`, `kbd up|down`): amixer
Master in 5% steps with the click sound, brightnessctl on the backlight (5%, never below 1%) or on
`*kbd_backlight` (1/16 steps), then a short dunst popup with a level bar (notify-send, with an
`x-dunst-stack-tag` so repeated presses replace one popup). Without a backlight device the
brightness keys do nothing.
The media keys (play/pause, next, previous, stop) run `playerctl`, so they control whichever MPRIS
player is running (mpv with mpv-mpris). W-m opens mpv with `--player-operation-mode=pseudo-gui`,
an empty window you can drop files on.
The autostart then runs `dex -a -e Openbox` for the XDG autostart entries (nm-applet,
blueman-applet, pasystray...): openbox-autostart's own `openbox-xdg-autostart` needs python-pyxdg
and runs nothing without it. The `environment` sets `QT_QPA_PLATFORMTHEME=gtk3` and unsets
`QT_STYLE_OVERRIDE`, so Qt apps follow the GTK theme (Artix's `/etc/environment` sets both to
`gtk4`, which is no Qt plugin). Notifications use the Homestead colours through a dunst drop-in
(dunst reads `/etc/dunst`, not `/etc/xdg`, when `XDG_CONFIG_DIRS` is unset), and KDE apps through
`/etc/xdg/kdeglobals`, which repeats the `Homestead` colour scheme's colours (KDE apps read them
from kdeglobals, not from the scheme file).
The `Homestead` icon theme ships no icons of its own: it inherits `Papirus-Dark`
(papirus-icon-theme), then `hicolor`, and the dunst drop-in looks icons up in the same order.

`notes/` holds investigation notes. `synergy/` holds my Synergy 3 setup (desktop shares
keyboard/mouse with a MacBook Pro 2019, macOS + Boot Camp). `CLAUDE.md` has build details and how a change gets shipped.

```sh
git clone --recurse-submodules https://github.com/ztancrell/homestead.git
```
