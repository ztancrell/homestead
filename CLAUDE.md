# homestead

Workspace for my patched Linux desktop stack (CachyOS, X11). This folder is the
umbrella repo ztancrell/homestead; each component dir is its own git repo, tracked
here as a submodule. Commit and push component changes inside that repo; commit
here only for submodule pointer bumps, `CLAUDE.md`, `README.md` and `notes/`
(investigation notes).

| Dir | Repo (origin) | Build | Installs to |
|---|---|---|---|
| `xserver` | ztancrell/xserver (XLibre) | meson, `build/`, prefix `/usr/local` | `/usr/local/bin/X`, modules in `/usr/local/lib/xorg/modules/xlibre-25` |
| `xf86-input-libinput` | ztancrell/xf86-input-libinput | meson, `build/`, setup with `PKG_CONFIG_PATH=/usr/local/lib/pkgconfig` (else it builds against stock headers and installs into `/usr`) | `/usr/local/lib/xorg/modules/xlibre-25/input/libinput_drv.so` |
| `xf86-video-amdgpu` | ztancrell/xf86-video-amdgpu | meson | not installed; X currently uses `modesetting` |
| `openbox` | ztancrell/openbox-patchwork | autotools, `--prefix=/usr/local --enable-debug` | `/usr/local/bin/openbox` |
| `fastcompmgr` | ztancrell/fastcompmgr | `make` | `/usr/local/bin/fastcompmgr` |
| `tint2` | ztancrell/tint2 (remote `upstream` = gitlab.com/o9000/tint2, frozen since 2022) | cmake, `build/`, `-DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_TINT2CONF=OFF` | `/usr/local/bin/tint2` |

## How the session runs

- Display manager: `ly` starts `/usr/local/bin/X`.
- `openbox --startup` runs `~/.config/openbox/autostart`, which launches
  `/usr/local/bin/fastcompmgr --refresh-rate 100` and
  `tint2 -c ~/.config/tint2/horizontal-text-only.tint2rc`.
- Stock pacman packages (`xlibre-xserver`, `openbox`, `fastcompmgr`, `tint2`)
  are still installed in `/usr/bin`; `/usr/local/bin` wins via PATH. A full-path
  `/usr/bin/...` launch gets the stock build.

## Testing and restarting

- Prefer testing WM/compositor/panel changes nested first: `Xephyr :1 -screen 1920x1080 &`
  then `DISPLAY=:1 <binary>`.
- fastcompmgr / tint2: kill and relaunch with the autostart arguments; harmless.
- openbox: `openbox --replace` (live session; a crash drops window management).
- xserver and Xorg modules: a new build only takes effect after logging out; never
  restart X without asking.
- Installing to `/usr/local` needs sudo; ask before installing.
