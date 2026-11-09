# homestead

Workspace for my patched Linux desktop stack (CachyOS, X11). This folder is the
umbrella repo ztancrell/homestead; each component dir is its own git repo, tracked
here as a submodule. Commit and push component changes inside that repo; commit
here only for submodule pointer bumps, `CLAUDE.md`, `README.md`, `notes/`
(investigation notes) and `synergy/` (Synergy 3 config, see `synergy/README.md`).

| Dir | Repo (origin) | Build (flags the PKGBUILD follows, prefix `/usr`) | Package (`../zpt2linux/pkgs/`) |
|---|---|---|---|
| `xserver` | ztancrell/xserver (XLibre) | meson, `build/` | `xlibre-xserver-homestead`: `/usr/bin/X`, modules in `/usr/lib/xorg/modules/xlibre-25` |
| `xf86-input-libinput` | ztancrell/xf86-input-libinput | meson, `build/`, built against the xserver headers | `xlibre-input-libinput-homestead` : `/usr/lib/xorg/modules/xlibre-25/input/libinput_drv.so` (fetches the submodule commit from upstream X11Libre until the fork has it) |
| `openbox` | ztancrell/openbox-patchwork | autotools, `--enable-debug` | `openbox-homestead`: `/usr/bin/openbox` |
| `fastcompmgr` | ztancrell/fastcompmgr | `make` | `fastcompmgr-homestead`: `/usr/bin/fastcompmgr` |
| `tint2` | ztancrell/tint2 (remote `upstream` = gitlab.com/o9000/tint2, frozen since 2022) | cmake, `build/`, `-DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_TINT2CONF=OFF` | `tint2-homestead`: `/usr/bin/tint2` |

The packages replace the stock `xlibre-xserver`, `xlibre-input-libinput`, `openbox`,
`fastcompmgr` and `tint2`; `zpt2linux-desktop` pulls them all in. They come from the local
`[zpt2linux]` repo (`sudo pacman -Syu`; first install `sudo pacman -S zpt2linux-desktop`).

To ship a component change: commit and push it in the fork, bump the submodule pointer here
and push, then in `../zpt2linux` bump `_commit` and `pkgver` in the matching PKGBUILD, run
`./build.sh`, and `sudo pacman -Syu`.

Superseded (2026-11-09): installed as pacman packages from ../zpt2linux, prefix /usr. The
components used to be built here and installed by hand into `/usr/local` (`--prefix=/usr/local`,
`CMAKE_INSTALL_PREFIX=/usr/local`, xf86-input-libinput set up with
`PKG_CONFIG_PATH=/usr/local/lib/pkgconfig`). Local `build/` dirs are still fine for testing.

## How the session runs

- Display manager: `ly` starts `/usr/bin/X` (`x_cmd` in `/etc/ly/config.ini`).
- `openbox --startup` runs `~/.config/openbox/autostart`, which launches
  `/usr/bin/fastcompmgr --refresh-rate 100` and
  `tint2 -c ~/.config/tint2/homestead.tint2rc`.
- Everything in `/usr/bin` is the homestead build; the stock packages are not installed.

## Testing and restarting

- Prefer testing WM/compositor/panel changes nested first: `Xephyr :1 -screen 1920x1080 &`
  then `DISPLAY=:1 <binary>`.
- fastcompmgr / tint2: kill and relaunch with the autostart arguments; harmless.
- openbox: `openbox --replace` (live session; a crash drops window management).
- xserver and Xorg modules: a new build only takes effect after logging out; never
  restart X without asking.
- Installing (`pacman`) needs sudo; ask before installing.
